param(
    # [string] $BicepSampleName = "101/azure-search-create",
    # [string] $QuickStartSampleName = "quickstarts/microsoft.search/azure-search-create",
    [string][Parameter(Mandatory = $true)] $BicepSampleName, # e.g. "101/sample"
    [string][Parameter(Mandatory = $true)] $QuickStartSampleName, # the name of the sample or folder path from the root of the repo e.g. "quickstarts/ms.abc/sample"
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw" #asdf
)

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force
$bicepFolder = getBicepFolder $ReposRoot $BicepSampleName
$quickStartFolder = getQuickStartFolder $ReposRoot $QuickStartSampleName
$bicepCommand = GetBicepCommand $ReposRootx

Write-Host "Bicep repo..."
cd $bicepFolder
git checkout main
ThrowIfExternalCmdFailed "Checkout failed"
git pull
ThrowIfExternalCmdFailed "Pull failed"
Write-Host "Creating new branch $PrPrefix/$BicepSampleName"
git checkout -b $PrPrefix/$BicepSampleName
ThrowIfExternalCmdFailed "Creating new branch failed"

CreateBicepMovedReadme $bicepFolder

git commit --allow-empty -m "Sync with quickstart: $QuickStartSampleName"

Write-Host "QuickStart repo..."
cd $QuickStartFolder
git checkout master
ThrowIfExternalCmdFailed "Checkout failed"
git pull
ThrowIfExternalCmdFailed "Pull failed"
Write-Host "Creating new branch $PrPrefix/$BicepSampleName"
git checkout -b $PrPrefix/$BicepSampleName
ThrowIfExternalCmdFailed "Creating new branch failed"

Write-Host "Preparing initial main.bicep in bicep repo..."
write-host "bicep decompile $QuickStartFolder/azuredeploy.json --outfile $BicepFolder/main.bicep"
& $bicepCommand decompile $QuickStartFolder/azuredeploy.json --outfile $BicepFolder/main.bicep

code $BicepFolder/main.bicep $QuickStartFolder/azuredeploy.json
