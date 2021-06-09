param(
    #[string] $BicepSampleName = "101/aad-domainservices", # e.g. "101/sample"
    #[string] $QuickStartSampleName = "101-aad-domainservices", # the name of the sample or folder path from the root of the repo e.g. "quickstarts/ms.abc/sample"
    [string][Parameter(Mandatory = $true)] $BicepSampleName, # e.g. "101/sample"
    [string][Parameter(Mandatory = $true)] $QuickStartSampleName, # the name of the sample or folder path from the root of the repo e.g. "quickstarts/ms.abc/sample"
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw"
)

Import-Module "$PsScript/Convert-Sample.psm1" -Force

cd "$ReposRoot/bicep/docs/examples/$BicepSampleName"
$BicepFolder = $PWD.Path
git add .
git commit -m "Sync up with quickstarts: $BicepSampleName"
bicep build "$BicepFolder/main.bicep"
git add "$BicepFolder/main.json"
git commit -m "Update JSON"

cd "$ReposRoot/azure-quickstart-templates/$QuickStartSampleName"
$QuickStartFolder = $PWD.Path
cp "$BicepFolder/main.bicep" "$QuickStartFolder"
cp "$BicepFolder/main.json" "$QuickStartFolder/azuredeploy.json"
& "$ReposRoot/azure-quickstart-templates/test/ci-scripts/Test-LocalSample.ps1" -Fix

git add .
git commit -m "Port bicep example into quickstart: $BicepSampleName"

gh pr 

code $QuickStartFolder/azuredeploy.json $QuickStartFolder/README.md $QuickStartFolder/metadata.json
