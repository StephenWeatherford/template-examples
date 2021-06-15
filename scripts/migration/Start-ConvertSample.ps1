param(
    [string][Parameter(Mandatory = $true)] $BicepSampleName, # e.g. "101/sample"
    [string] $ReposRoot = "~/repos",
    [string] $PrPrefix = "sw" #asdf
)

$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force
$bicepFolder = getBicepFolder $ReposRoot $BicepSampleName
$row, $QuickStartSampleName, $quickStartMoved = FindQuickStartFromBicepExample $BicepSampleName -ThrowIfNotFound
$QuickStartFolder = GetQuickStartFolder $ReposRoot $quickStartSampleName
$bicepCommand = GetBicepCommand $ReposRoot

Write-Host "Preparing initial bicep files in bicep repo..."
checkout $bicepFolder $PrPrefix/$BicepSampleName
#write-host "bicep decompile $QuickStartFolder/azuredeploy.json --outfile $BicepFolder/main.bicep"
cp $QuickStartFolder/azuredeploy.json $BicepFolder/main.json
git add $BicepFolder/*.json
git commit -m "Original JSON files from the quickstart sample"
Write-Host "Decompiling main.json using bicep at: $bicepCommand"
$params = $bicepCommand + @("decompile", "$BicepFolder/main.json")
$cmd = $params[0]
$params = $params[1..100] 
start-process $cmd $params -wait

code $BicepFolder/main.bicep $QuickStartFolder/azuredeploy.json
