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
$bicepCommand = GetBicepCommand $ReposRoot

Write-Host "Bicep repo..."
Checkout $bicepFolder main
git pull
ThrowIfExternalCmdFailed "Pull failed"
Write-Host "Creating new branch $PrPrefix/$BicepSampleName"
checkout $bicepFolder $PrPrefix/$BicepSampleName -New

CreateBicepMovedReadme $bicepFolder
cd $bicepFolder
git add .
git commit --allow-empty -m "Sync with quickstart: $QuickStartSampleName"

Write-Host "QuickStart repo..."
checkout $QuickStartFolder master
git pull
ThrowIfExternalCmdFailed "Pull failed"
Write-Host "Creating new branch $PrPrefix/$BicepSampleName"
checkout $QuickStartFolder $PrPrefix/$BicepSampleName -New
