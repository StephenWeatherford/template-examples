param(
    [string][Parameter(Mandatory = $true)] $NewBranchName,
    [string] $BicepSampleName, # e.g. "101/sample", or $null for all
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw"
)

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force

Write-Host "Getting tables..."
$quickStartTable = GetQuickStartTable
$conversionsTable = GetBicepConversionsTable

checkout $ReposRoot/bicep main
git pull
checkout $ReposRoot/azure-quickstart-templates master
git pull

CheckOut $ReposRoot/bicep $NewBranchName -New

function Update {
    [CmdletBinding()]
    param (
        [string][Parameter(Mandatory = $true)] $bsn # bicep sample name
    )

    Write-Host $bsn

    $bicepFolder = getBicepFolder $ReposRoot $bsn
    $row, $QuickStartSampleName, $quickStartMoved, $hasQuickStart = FindQuickStartFromBicepExample $BicepSampleName $quickStartTable $conversionsTable
    if (!$hasQuickStart) {
        return
    }

    $QuickStartFolder = GetQuickStartFolder $ReposRoot $quickStartSampleName
    if (!(Test-Path "$QuickStartFolder/main.bicep")) {
        # Quickstart doesn't have bicep file checked in yet
        return
    }

    cd $bicepFolder

    rm $bicepFolder/README*.md
    CreateBicepMovedReadme $bicepFolder $QuickStartSampleName
    Write-Host "Copying *.bicep from $QuickStartFolder to $BicepFolder"
    cp $QuickStartFolder/*.bicep $BicepFolder
}

if ($BicepSampleName) {
    Update $BicepSampleName
}
else {
    $bicepFiles = Get-ChildItem -Recurse "$ReposRoot/bicep/docs/examples" -include "main.bicep" | Select -ExpandProperty FullName
    foreach ($mainBicep in $bicepFiles) {
        $matches = $mainBicep | Select-String -Pattern "([0-9][0-9][0-9]/.*)/main.bicep$"
        $BicepSampleName = $matches.matches[0].groups[1] | select -expandproperty Value
        update $BicepSampleName
    }
}

Write-Host "Updating bicep baselines"
UpdateBicepBaseline $ReposRoot

#code $bicepFolder/*.bicep $bicepFolder/*.json $bicepFolder/*.md
