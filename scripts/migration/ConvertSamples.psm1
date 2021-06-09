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
    [OutputType([string])]
    param (
        [string]$ReposRoot
    )

    $path = "src/Bicep.Cli/bin/Debug/net5.0/bicep.dll"
    if (Test-Path $path) {
        return "dotnet $path";
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
"@ | Out-File $bicepFolder/README.md
}

function UpdateBicepBaseline {
    param (
        [string][parameter(Mandatory = $true)] $ReposRoot
    )

    cd "$ReposRoot/bicep"
    dotnet test --filter "TestCategory=Baseline&FullyQualifiedName~Bicep.Core.Samples" -- 'TestRunParameters.Parameter(name=\"SetBaseLine\", value=\"true\")'
}

function CheckOut {
    param (
        [string][parameter(Mandatory = $true)] $RepoPath,
        [string][parameter(Mandatory = $true)] $Branch,
        [switch] $New
    )

    if ($New) {
        git checkout -b $Branch
        ThrowIfExternalCmdFailed "Checkout of new branch $Branch failed"
    }
    else {
        git checkout $Branch
        ThrowIfExternalCmdFailed "Checkout of $Branch failed"
    }
}