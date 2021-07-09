$PersistentFile = "$env:HOME/.persistentValues"
function SetPersistentValue(
    [string][parameter(Mandatory = $true)] $key,
    [string][parameter(Mandatory = $true)] $value) {
    $values = GetPersistentValues
    $values | Add-Member -MemberType NoteProperty -Name $key -Value $value -Force
    $values | ConvertTo-Json | Set-Content $PersistentFile
}

function GetPersistentValues() {
    if (Test-Path $PersistentFile) {
        return Get-Content $PersistentFile | ConvertFrom-Json
    }
    else {
        return New-Object -TypeName psobject
    }
}

function GetPersistentValue([string][parameter(Mandatory = $true)] $key) {
    return GetPersistentValues | Select-Object -Property $key -ExpandProperty $key -ErrorAction Ignore
}

function GetBicepFolder {
    [OutputType([string])]
    param (
        [string][parameter(Mandatory = $true)] $ReposRoot,
        [string][parameter(Mandatory = $true)] $BicepSampleName
    )
    if (!(Test-Path "$ReposRoot/bicep/docs/examples/$BicepSampleName")) {
        throw "Could not find bicep example: $ReposRoot/bicep/docs/examples/$BicepSampleName"
    }
    cd "$ReposRoot/bicep/docs/examples/$BicepSampleName"
    return $PWD.Path    
}

function GetQuickStartFolder {
    [OutputType([string])]
    param (
        [string][parameter(Mandatory = $true)] $ReposRoot,
        [string][parameter(Mandatory = $true)] $QuickStartSampleName
    )
    if (!(Test-Path "$ReposRoot/azure-quickstart-templates/$QuickStartSampleName")) {
        throw "Could not find quickstarts sample: $ReposRoot/azure-quickstart-templates/$QuickStartSampleName"
    }
    cd "$ReposRoot/azure-quickstart-templates/$QuickStartSampleName"
    return $PWD.Path
}

function GetBicepCommand {
    [OutputType([string[]])]
    param (
        [string][parameter(Mandatory = $true)] $ReposRoot
    )

    $path = "$ReposRoot/bicep/src/Bicep.Cli/bin/Debug/net5.0/bicep.dll"
    if (Test-Path $path) {
        return "dotnet", (Resolve-Path $path)
    }

    return "bicep"
}

function UpdateDateInMetadata(
    [string][parameter(Mandatory = $true)] $quickStartFolder
) {
    $metadataFn = "$quickStartFolder/metadata.json"
    $metadata = Get-Content $metadataFn -Raw
    $newDate = get-date -format "yyyy-MM-dd"
    $metadata = $metadata -replace """dateUpdated"": ""[0-9-]+""", """dateUpdated"": ""$newDate"""
    Set-Content $metadataFn $metadata.Trim()
}

function ThrowIfExternalCmdFailed([string]$message) {
    if (!$?) {
        throw $message ?? "External command failed"
    }    
}

function CreateBicepMovedReadme {
    param (
        [string][parameter(Mandatory = $true)] $bicepFolder,
        [string][parameter(Mandatory = $true)] $QuickStartSampleName
    )

    @"
# Migration of examples

The bicep examples are being integrated into the [Azure QuickStart Template repo](https://github.com/Azure/azure-quickstart-templates).

This sample has been moved to https://github.com/Azure/azure-quickstart-templates/tree/master/$QuickStartSampleName.

It will also remain here as reference for the time being.
"@ | Out-File $bicepFolder/README-MOVED.md
}

function UpdateBicepBaseline {
    param (
        [string][parameter(Mandatory = $true)] $ReposRoot
    )

    Write-Host "Updating the bicep baselines (updating main.json to match main.bicep)"
    cd "$ReposRoot/bicep/src/Bicep.Core.Samples"
    dotnet test --filter "TestCategory=Baseline&FullyQualifiedName~Bicep.Core.Samples" -- 'TestRunParameters.Parameter(name=\"SetBaseLine\", value=\"true\")'
}

function CheckOut {
    param (
        [string][parameter(Mandatory = $true)] $RepoPath,
        [string][parameter(Mandatory = $true)] $Branch,
        [switch] $New
    )

    cd $RepoPath
    if ($New) {
        git checkout -b $Branch
        ThrowIfExternalCmdFailed "Checkout of new branch $Branch failed"
    }
    else {
        git checkout $Branch
        ThrowIfExternalCmdFailed "Checkout of $Branch failed"
    }
}

function GetQuickStartTable {
    param(
        [string]$StorageAccountName = "azurequickstartsservice",
        [string]$StorageAccountResourceGroupName = "azure-quickstarts-service-storage",
        [string]$TableName = "QuickStartsMetadataService"
    )

    # Get the storage table that contains the "status" for the deployment/test results
    $ctx = (Get-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $StorageAccountResourceGroupName).Context

    $cloudTable = (Get-AzStorageTable –Name $tableName –Context $ctx).CloudTable
    $t = Get-AzTableRow -table $cloudTable
    return $t
}

function GetBicepConversionsTable {
    param(
        [string]$StorageAccountName = "azureqsbicep",
        [string]$StorageAccountResourceGroupName = "azure-quickstarts-service-storage",
        [string]$TableName = "bicepConversions"
    )

    # Get the storage table that contains the "status" for the deployment/test results
    $ctx = (Get-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $StorageAccountResourceGroupName).Context

    $cloudTable = (Get-AzStorageTable –Name $tableName –Context $ctx).CloudTable
    $t = Get-AzTableRow -table $cloudTable
    return $t
}

function FindQuickStartFromBicepExample {
    param (
        [string][Parameter(Mandatory = $true)] $bicepSampleName,
        [object] $Table,
        [object] $ConversionsTable,
        [switch] $ThrowIfNotFound,
        [switch] $NoCache
    )

    Write-Host "Searching for quickstart sample matching bicep example $bicepSampleName..."

    $quickStartMoved = $false
    $hasQuickStart = $false

    $level = split-path (Split-Path $bicepSampleName -Parent) -Leaf # This is the name of the parent folder ("101", "201", etc.)
    $sampleShortName = Split-Path $bicepSampleName -Leaf

    if (!$NoCache) {
        $currentBicepSample = GetPersistentValue "bicepSampleName"
        if ($currentBicepSample -eq $bicepSampleName) {
            $quickStartSampleName = GetPersistentValue "quickStartSampleName"
            $quickStartMoved = GetPersistentValue "quickStartMoved"
            $hasQuickStart = GetPersistentValue "quickStartMoved"
        }
    }

    if (!$quickStartSampleName) {
        if (!$ConversionsTable) {
            $ConversionsTable = GetBicepConversionsTable
        }

        # First check for a new quickstart entry
        $r = $ConversionsTable | Where-Object { ($_.PartitionKey -eq $level) -and ($_.RowKey -eq $sampleShortName) }
        if ($r) {
            $quickStartSampleName = $r.QuickStart
            $hasQuickStart = $false
        }
        else {
            if (!$Table) {
                $Table = GetQuickStartTable
            }

            # Next, try against the new, reorganized quickstarts, e.g. application-workloads@active-directory@active-directory-new-domain
            # In this case, we match without the level, and must match the full leaf name
            $r = $Table | Where-Object { $_.RowKey -like "*@" + $sampleShortName }
            if ($r -and ($r.RowKey -is [string])) {
                $quickStartSampleName = $r.RowKey.Replace("@", "/")
                $quickStartMoved = $true
                $hasQuickStart = $true
            }
            else {
                # Finally use the full bicep sample name matching exactly against the old full quickstart name, which includes the "level",
                # e.g. "201-vm" (before being reorganized into new folder structures)
                $r = $Table | Where-Object { $_.RowKey -eq $quickStartSampleName }
                if ($r) {
                    $hasQuickStart = $true
                }
            }
        }

        if ($null -eq $r) {
            if ($ThrowIfNotFound) {
                throw "Could not find a quickstart sample for Bicep example $bicepSampleName"
            }

            Write-Host "Found no matching quickstart samples."
            return $null, $null, $null
        }
        else {
            if ($hasQuickStart) {            
                Write-Host "Found existing quickstart sample: $quickStartSampleName"
            }
            else {
                Write-Host "Found NEW quickstart sample: $quickStartSampleName"
            }

            if ($r -is [array]) {
                throw "Found multiple matches for $bicepSampleName"
            }
            if (!($r.RowKey -is [string])) {
                throw "RowKey $r.RowKey is not a string"
            }
        }
    }
    
    if (!$NoCache) {
        SetPersistentValue "bicepSampleName" $bicepSampleName
        SetPersistentValue "quickStartSampleName" $quickStartSampleName
        SetPersistentValue "quickStartMoved" $quickStartMoved
        SetPersistentValue "quickStartMoved" $hasQuickStart
    }

    return $r, $quickStartSampleName, $quickStartMoved, $hasQuickStart
}
