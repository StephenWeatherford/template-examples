param(
    [string][Parameter(Mandatory = $true)] $BicepSampleName, # e.g. "101/sample"
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw"
)

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force
$bicepFolder = getBicepFolder $ReposRoot $BicepSampleName
$row, $QuickStartSampleName, $quickStartMoved = FindQuickStartFromBicepExample $BicepSampleName -ThrowIfNotFound
$QuickStartFolder = GetQuickStartFolder $ReposRoot $quickStartSampleName

cd $bicepFolder
CheckOut $ReposRoot/bicep $PrPrefix/$BicepSampleName

UpdateBicepBaseline $ReposRoot

CheckOut $QuickStartFolder $PrPrefix/$BicepSampleName

updateDateInMetadata $quickStartFolder
git add metadata.json
git commit -m "Integrate bicep sample $BicepSampleName"

CheckOut $QuickStartFolder $PrPrefix/$BicepSampleName
Write-Host "Copying $BicepFolder/main.bicep to $QuickStartFolder"
cp $BicepFolder/*.bicep $QuickStartFolder
bicep build main.bicep --outfile azuredeploy.json
& "$ReposRoot/azure-quickstart-templates/test/ci-scripts/Test-LocalSample.ps1" -Fix

updateDateInMetadata $quickStartFolder

cd $quickStartFolder
git add .

code $QuickStartFolder/main.bicep $QuickStartFolder/azuredeploy.json $QuickStartFolder/README.md $QuickStartFolder/metadata.json
