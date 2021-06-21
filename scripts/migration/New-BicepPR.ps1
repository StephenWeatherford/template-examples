param(
    [string][Parameter(Mandatory = $true)] $BicepSampleName, # e.g. "101/sample"
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw"
)

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force
$bicepFolder = getBicepFolder $ReposRoot $BicepSampleName
$row, $QuickStartSampleName, $quickStartMoved, $hasQuickStart = FindQuickStartFromBicepExample $BicepSampleName -ThrowIfNotFound
$QuickStartFolder = GetQuickStartFolder $ReposRoot $quickStartSampleName

CheckOut $bicepFolder $PrPrefix/$BicepSampleName

$body = @"
Updated bicep code.
Copied bicep.main to QuickStart sample in https://github.com/Azure/azure-quickstart-templates$quickStartSampleName
Added readme to indicate that this sample has now been moved (although it will remain here as well for the time being)

The corresponding PR for the modified quickstart is here: <TODO: Fill in>
"@
gh pr create --title "Migrate example: $BicepSampleName" --body $body --repo "Azure/bicep" --label "bicep example migration" --draft