param(
    [string][Parameter(Mandatory = $true)] $BicepSampleName, # e.g. "101/sample"
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw", #asdf
    [switch] $D
)

$ErrorActionPreference = "Stop"

$deleteFlag = $D ? "-D" : "-d"

Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force
#$bicepFolder = getBicepFolder $ReposRoot $BicepSampleName
#$row, $QuickStartSampleName, $quickStartMoved, $hasQuickStart = FindQuickStartFromBicepExample $BicepSampleName -ThrowIfNotFound
#$QuickStartFolder = GetQuickStartFolder $ReposRoot $quickStartSampleName

Write-Host "Bicep: Deleting branch: $PrPrefix/$BicepSampleName"
checkout $ReposRoot/bicep main 
git branch $deleteFlag $PrPrefix/$BicepSampleName

Write-Host "QuickStarts: Deleting branch: $PrPrefix/$BicepSampleName"
checkout $ReposRoot/azure-quickstart-templates master 
git branch $deleteFlag $PrPrefix/$BicepSampleName
