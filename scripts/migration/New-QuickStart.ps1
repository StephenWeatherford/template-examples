# Creates a new quickstart sample from a Bicep example that doesn't already come from a quickstart
param(
    [string][Parameter(Mandatory = $false)] $BicepSampleName = "101/cyclecloud", # e.g. "101/sample"
    [string][Parameter(Mandatory = $false)] $QuickStartSampleName = "quickstarts/microsoft.compute/vm-cyclecloud", # e.g. 
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw", #asdf
    [boolean] $PR = $true
)

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force
$bicepFolder = getBicepFolder $ReposRoot $BicepSampleName
#$row, $QuickStartSampleNameExisting, $quickStartMoved, $hasQuickStart = FindQuickStartFromBicepExample $BicepSampleName
#if ($hasQuickStart) {
#    throw "There's already an existing quickstart for this bicep example"
#}

cd "$ReposRoot/azure-quickstart-templates"
$resolvedQuickStarts = $PWD.Path
mkdir -v "$($resolvedQuickStarts)/$($quickStartSampleName)"

$QuickStartFolder = GetQuickStartFolder $ReposRoot $quickStartSampleName
$bicepCommand = GetBicepCommand $ReposRoot

# ... get original author
$bicepFolder = GetBicepFolder $ReposRoot $BicepSampleName
Set-Location $BicepFolder
$sampleAuthor = & git log --pretty=format:'%an' $bicepPath | tail -1 # Author who checked in the first version of the example
Write-Host "AUTHOR: $SampleAuthor"

#Write-Host "Preparing initial bicep files in bicep repo..."
# checkout $bicepFolder $PrPrefix/$BicepSampleName -New
# CreateBicepMovedReadme $bicepFolder
# cd $bicepFolder
# git add .
# git commit --allow-empty -m "Sync with new quickstart: $QuickStartSampleName"

Write-Host "Preparing initial files in quickstarts repo..."
$PRName = "$PrPrefix/new/$BicepSampleName"
checkout $QuickStartFolder $PRName -new
git commit -m --allow-empty "New quickstart from bicep: $BicepSampleName"

cp $BicepFolder/main.json $QuickStartFolder/azuredeploy.json
cp $BicepFolder/*.bicep $QuickStartFolder
git add $QuickStartFolder/*.*
git commit -m "Original files from $BicepSampleName"

# Readme
if (Test-Path $bicepFolder/README.md) {
    cat $bicepFolder/README.md > $QuickStartFolder/README.md
    echo '' >> $QuickStartFolder/README.md
    echo 'TODO: Clean up README' >> $QuickStartFolder/README.md
}
else {
    Set-Content $QuickStartFolder/README.md "# TODO: Create ReadMe"
}

# Create params file
$template = Get-Content $QuickStartFolder/azuredeploy.json | ConvertFrom-JSON
$params = $template.parameters.psobject.properties.name
$paramsWithNoDefault = $params | where-object { $template.parameters.$_.defaultValue -eq $null }
$paramsJson = $paramsWithNoDefault | ForEach-Object { """$_"": {value:""TODO""}" }
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
    "githubUsername": "$sampleAuthor (TODO: find correct github username)",
    "dateUpdated": "$(get-date -format "yyyy-MM-dd")"
}
"@
Set-Content $QuickStartFolder/metadata.json $metadata

git add $QuickStartFolder/*.*
git commit -m "Create draft supporting files"

code $QuickStartFolder/*.bicep $QuickStartFolder/README.md $QuickStartFolder/azuredeploy.json $QuickStartFolder/metadata.json

# Fix readme links
$ErrorActionPreference = "Continue"
& "$ReposRoot/azure-quickstart-templates/test/ci-scripts/Test-LocalSample.ps1" -Fix -ErrorAction Ignore | out-null 2>&1
$ErrorActionPreference = "Stop"
git add ./README.md
git commit -m "Fix readme links"

git push --set-upstream origin $PRName

# PR
if ($PR) {
    $body = @"
Created a new QuickStart sample from the bicep example in https://github.com/Azure/bicep/tree/main/docs/examples/$BicepSampleName

See the contribution guide here: https://github.com/Azure/azure-quickstart-templates/blob/master/1-CONTRIBUTION-GUIDE/README.md
"@
    gh pr create --title "New from bicep example: $BicepSampleName" --body $body --label "bicep example migration" --repo "Azure/azure-quickstart-templates"
}
