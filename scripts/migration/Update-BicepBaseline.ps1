param(
    [string][Parameter(Mandatory = $true)] $BicepSampleName, # e.g. "101/sample"
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw"
)

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force
$bicepFolder = getBicepFolder $ReposRoot $BicepSampleName

CheckOut $ReposRoot/bicep $PrPrefix/$BicepSampleName
UpdateBicepBaseline $ReposRoot
git add .
