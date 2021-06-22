param(
    [string][Parameter(Mandatory = $true)] $BicepSampleName, # e.g. "101/sample"
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw" #asdf
)

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force

$bicepFolder = getBicepFolder $ReposRoot $BicepSampleName
$row, $QuickStartSampleName, $quickStartMoved, $hasQuickStart = FindQuickStartFromBicepExample $BicepSampleName -ThrowIfNotFound
$QuickStartFolder = GetQuickStartFolder $ReposRoot $quickStartSampleName

Write-Host "Bicep: Checking out: $PrPrefix/$BicepSampleName"
checkout $bicepFolder $PrPrefix/$BicepSampleName

Write-Host "QuickStarts: Checking out: $PrPrefix/$BicepSampleName"
checkout $QuickStartFolder $PrPrefix/$BicepSampleName

code $bicepFolder/main.bicep
code $QuickStartFolder/main.bicep
