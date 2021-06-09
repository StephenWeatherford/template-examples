param(
    [string][Parameter(Mandatory = $true)] $BicepSampleName, # e.g. "101/sample"
    [string][Parameter(Mandatory = $true)] $QuickStartSampleName, # the name of the sample or folder path from the root of the repo e.g. "quickstarts/ms.abc/sample"
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw" #asdf
)

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force
$bicepFolder = GetBicepFolder $ReposRoot $BicepSampleName

CheckOut $ReposRoot/bicep $PrPrefix/$BicepSampleName
CreateBicepMovedReadme $bicepFolder $QuickStartSampleName
