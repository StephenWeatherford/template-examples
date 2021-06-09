param(
    [string] $BicepSampleName = "101/azure-bastion", # e.g. "101/sample"
    [string] $QuickStartSampleName = "quickstarts/microsoft.network/azure-bastion", # the name of the sample or folder path from the root of the repo e.g. "quickstarts/ms.abc/sample"
    # [string][Parameter(Mandatory = $true)] $BicepSampleName, # e.g. "101/sample"
    # [string][Parameter(Mandatory = $true)] $QuickStartSampleName, # the name of the sample or folder path from the root of the repo e.g. "quickstarts/ms.abc/sample"
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw"
)

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force
$bicepFolder = getBicepFolder $ReposRoot $BicepSampleName
$quickStartFolder = getQuickStartFolder $ReposRoot $QuickStartSampleName

cd $bicepFolder
CheckOut $ReposRoot/bicep $PrPrefix/$BicepSampleName

CreateBicepMovedReadme $bicepFolder $QuickStartSampleName
UpdateBicepBaseline $ReposRoot

cd $QuickStartFolder
CheckOut $ReposRoot/azure-quickstart-templates $PrPrefix/$BicepSampleName
cp "$BicepFolder/main.bicep" "$QuickStartFolder"
bicep build main.bicep --outfile azuredeploy.json
& "$ReposRoot/azure-quickstart-templates/test/ci-scripts/Test-LocalSample.ps1" -Fix

updateDateInMetadata $quickStartFolder

git add .
# git commit -m "Port bicep example into quickstart: $BicepSampleName"

code $QuickStartFolder/main.bicep $QuickStartFolder/azuredeploy.json $QuickStartFolder/README.md $QuickStartFolder/metadata.json
