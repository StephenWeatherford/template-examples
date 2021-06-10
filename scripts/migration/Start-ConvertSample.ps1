param(
    [string][Parameter(Mandatory = $true)] $BicepSampleName, # e.g. "101/sample"
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw" #asdf
)

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force
$bicepFolder = getBicepFolder $ReposRoot $BicepSampleName
$row, $QuickStartSampleName, $quickStartMoved = FindQuickStartFromBicepExample $BicepSampleName -ThrowIfNotFound
$QuickStartFolder = GetQuickStartFolder $ReposRoot $quickStartSampleName

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
cd $bicepFolder
git add .
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
vi decompile $QuickStartFolder/azuredeploy.json --outfile $BicepFolder/main.bicep

code $BicepFolder/main.bicep $QuickStartFolder/azuredeploy.json
