#Requires -Module AzTable

<#

Matches bicep samples in the bicep repo with existing QuickStarts samples

#>

param(
    [string]$BicepRepoPath = "~/repos/bicep",
    # [string]$QuickStartsRepoPath = "~/repos/azure-quickstart-templates",
    [string]$StorageAccountName = "azurequickstartsservice",
    [string]$StorageAccountResourceGroupName = "azure-quickstarts-service-storage",
    [string]$TableName = "QuickStartsMetadataService",
    $ResultDeploymentLastTestDateParameter = "PublicLastTestDate", # sort based on the cloud we're testing (FairfaxLastTestDate or PublicLastTestDate)
    $ResultDeploymentParameter = "PublicDeployment" # PublicDeployment or FairfaxDeployment
)

# Get the storage table that contains the "status" for the deployment/test results
$ctx = (Get-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $StorageAccountResourceGroupName).Context

$cloudTable = (Get-AzStorageTable –Name $tableName –Context $ctx).CloudTable
$t = Get-AzTableRow -table $cloudTable

# # Get all the quickstart samples from disk
# $ArtifactFilePaths = Get-ChildItem $QuickStartsRepoPath\metadata.json -Recurse -File | ForEach-Object -Process { $_.FullName }
# Write-Host $ArtifactFilePaths

# if ($ArtifactFilePaths.Count -eq 0) {
#     Write-Error "No metadata.json files found in $QuickStartsRepoPath"
#     throw
# }

# Get all the bicep samples
$BicepTemplateFilePaths = Get-ChildItem "$BicepRepoPath\docs\examples\main.bicep" -Recurse -File | ForEach-Object -Process { $_.FullName }
Write-Host $BicepTemplateFilePaths

$outputRows = @()

# Create a left join of the bicep and quick-start samples (from the table)
foreach ($bicepPath in $BicepTemplateFilePaths) {
    $folder = split-path $bicepPath -Parent
    $level = split-path (Split-Path $folder -Parent) -Leaf # This is the name of the parent folder ("101", "201", etc.)
    $sampleShortName = Split-Path $folder -Leaf
    $quickStartSampleName = "$level-$sampleShortName"
    $bicepSampleName = "$level/$sampleShortName"
    $bicepFolder = "docs/examples/$level/$sampleShortName"

    $quickStartMoved = $false
    $r = $t | Where-Object { $_.RowKey -eq $quickStartSampleName }
    if ($null -eq $r) {
        Write-Host $sampleShortName
        $r = $t | Where-Object { $_.RowKey -like "*" + $sampleShortName }
        if (!($r.RowKey -is [string])) {
            Write-Host "whoops: key not string: ${$r.RowKey}"
        }
        if ($r -and ($r.RowKey -is [string])) {
            $quickStartSampleName = $r.RowKey.Replace("@", "/")
            $quickStartMoved = $true
        }
    }

    if ($null -eq $r) {
        # No match found with quickstarts
        $row = [PSCustomObject]@{
            BicepPath = $bicepFolder
            Name      = $bicepSampleName

            BestPracticeResult = $null
            FairfaxDeployment  = $null
            PublicDeployment   = $null
            Status             = $null
            QuickStartUri      = $null
            BicepUri           = $null
            QuickStartMoved    = $null

        } 
    }
    else {
        # It matches a quick-start entry in the table
        $row = [PSCustomObject]@{
            Name               = $bicepSampleName
            BicepPath          = $bicepFolder
            BestPracticeResult = $r.BestPracticeResult
            FairfaxDeployment  = $r.FairfaxDeployment
            PublicDeployment   = $r.PublicDeployment
            Status             = $r.status
            QuickStartUri      = "https://github.com/Azure/azure-quickstart-templates/tree/master/$quickStartSampleName"
            BicepUri           = "https://github.com/Azure/bicep/tree/main/$bicepFolder"
            QuickStartMoved    = $quickStartMoved ? "TRUE" : "FALSE"
        }
    }

    $outputRows += $row
    Write-Output $row | fl * 
}

$outputRows | Export-Csv "a.csv"