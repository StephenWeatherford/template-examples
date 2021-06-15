function GetBicepFolder {
    [OutputType([string])]
    param (
        [string]$ReposRoot,
        [string]$BicepSampleName
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
        [string]$ReposRoot,
        [string]$QuickStartSampleName
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
        [string]$ReposRoot
    )

    $path = "$ReposRoot/bicep/src/Bicep.Cli/bin/Debug/net5.0/bicep.dll"
    if (Test-Path $path) {
        return "dotnet", (Resolve-Path $path)
    }

    return "bicep"
}

function UpdateDateInMetadata([string][parameter(Mandatory = $true)] $quickStartFolder) {
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
        [string]$bicepFolder,
        [string]$QuickStartSampleName
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

    Write-Host "Updating the bicep baseline (updating main.json to match main.bicep)"
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

function FindQuickStartFromBicepExample {
    param (
        [string][Parameter(Mandatory = $true)] $bicepSampleName,
        [object] $Table,
        [switch] $ThrowIfNotFound
    )

    Write-Host "Searching for quickstart sample matching bicep example $bicepSampleName..."

    if (!$Table) {
        $Table = GetQuickStartTable
    }

    $quickStartMoved = $false

    $level = split-path (Split-Path $bicepSampleName -Parent) -Leaf # This is the name of the parent folder ("101", "201", etc.)
    $sampleShortName = Split-Path $bicepSampleName -Leaf
    $quickStartSampleName = "$level-$sampleShortName"

    # First use the full bicep sample name matching exactly against the old full quickstart name, which includes the "level",
    # e.g. "201-vm" (before being reorganized into new folder structures)
    $r = $Table | Where-Object { $_.RowKey -eq $quickStartSampleName }
    if ($null -eq $r) {
        # Next, try against the new, reorganized quickstarts, e.g. application-workloads@active-directory@active-directory-new-domain
        # In this case, we match without the level, and must match the full leaf name
        $r = $Table | Where-Object { $_.RowKey -like "*@" + $sampleShortName }
        if ($r -and ($r.RowKey -is [string])) {
            $quickStartSampleName = $r.RowKey.Replace("@", "/")
            $quickStartMoved = $true
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
        Write-Host "Found quickstart sample: $quickStartSampleName"

        if ($r -is [array]) {
            throw "Found multiple matches for $bicepSampleName"
        }
        if (!($r.RowKey -is [string])) {
            throw "RowKey $r.RowKey is not a string"
        }
    }

    return $r, $quickStartSampleName, $quickStartMoved
}
    