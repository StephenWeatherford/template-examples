param(
    [string][Parameter(Mandatory = $true)] $BicepSampleName, # e.g. "101/sample"
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw" #asdf
)

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force
$bicepFolder = getBicepFolder $ReposRoot $BicepSampleName
$row, $QuickStartSampleName, $quickStartMoved, $hasQuickStart = FindQuickStartFromBicepExample $BicepSampleName -ThrowIfNotFound
if ($hasQuickStart) {
    throw "There's already an existing quickstart for this bicep example"
}

cd "$ReposRoot/azure-quickstart-templates"
$resolvedQuickStarts = $PWD.Path
mkdir -v "$($resolvedQuickStarts)/$($quickStartSampleName)"

$QuickStartFolder = GetQuickStartFolder $ReposRoot $quickStartSampleName    
$bicepCommand = GetBicepCommand $ReposRoot

Write-Host "Preparing initial bicep files in bicep repo..."

checkout $bicepFolder $PrPrefix/$BicepSampleName
CreateBicepMovedReadme $bicepFolder
cd $bicepFolder
git add .
git commit --allow-empty -m "Sync with new quickstart: $QuickStartSampleName"

Write-Host "Preparing initial files in quickstarts repo..."
checkout $QuickStartFolder $PrPrefix/$BicepSampleName
git commit -m --allow-empty "New quickstart from bicep: $BicepSampleName"

cp $BicepFolder/main.json $QuickStartFolder/azuredeploy.json
cp $BicepFolder/*.bicep $QuickStartFolder
git add $QuickStartFolder/*.*
git commit -m "Original files from $BicepSampleName"

# Readme
if (Test-Path $bicepFolder/README.md) {
    cp $bicepFolder/README.md $QuickStartFolder
}
else {
    Set-Content $QuickStartFolder/README.md "# TODO: Create ReadMe"
}

# Params file
$template = Get-Content $QuickStartFolder/azuredeploy.json | ConvertFrom-JSON
$params = $template.parameters.psobject.properties.name
$paramsJson = $params | ForEach-Object { """$_"": {value:""TODO""}" }
$paramsFile = @'
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
'@ `
    + ($paramsJson -join ",") `
    + `
    @"
    }
}
"@
$paramsFile = $paramsFile | ConvertFrom-Json | ConvertTo-Json
Set-Content $QuickStartFolder/azuredeploy.parameters.json $paramsFile

# Build
bicep build main.bicep --outfile azuredeploy.json

# metadata.json
$metadata = @"
{
    "$('$')schema": "https://aka.ms/azure-quickstart-templates-metadata-schema#",
    "itemDisplayName": "TODO: short description (max len: 60). Same as top line of README?",
    "description": "TODO",
    "summary": "TODO",
    "type": "QuickStart",
    "githubUsername": "TODO",
    "dateUpdated": "$(get-date -format "yyyy-MM-dd")"
}
"@
Set-Content $QuickStartFolder/metadata.json $metadata

git add $QuickStartFolder/*.*
git commit -m "Create draft supporting files"

code $QuickStartFolder/main.bicep $QuickStartFolder/README.md $QuickStartFolder/azuredeploy.json $QuickStartFolder/metadata.json

# Fix readme links
& "$ReposRoot/azure-quickstart-templates/test/ci-scripts/Test-LocalSample.ps1" -Fix
git commit -m "Fix readme links"

