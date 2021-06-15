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

CheckOut $QuickStartFolder $PrPrefix/$BicepSampleName

$body = @"
Added bicep support to this sample by integrating bicep.main from the example in https://github.com/Azure/bicep/tree/main/docs/examples/$BicepSampleName

The corresponding PR for the modified bicep example is here: <TODO: Fill in>
"@
gh pr create --title "Migrate bicep example: $BicepSampleName" --body $body --label "bicep example migration" --repo "Azure/azure-quickstart-templates"