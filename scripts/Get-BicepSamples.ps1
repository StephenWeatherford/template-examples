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
    $ResultDeploymentParameter = "PublicDeployment", # PublicDeployment or FairfaxDeployment
    $OutputFilename = "~/bicepsamples"
)

$currentFolder = Get-Location
try {

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

        Set-Location (Split-Path -Parent $bicepPath)
        $sampleAuthor = & git log  --pretty=format:'%an' $bicepPath | tail -1 # Author who checked in the first version of the example

        $quickStartMoved = $false

        # First use the full bicep sample name matching exactly against the old full quickstart name, which includes the "level",
        # e.g. "201-vm" (before being reorganized into new folder structures)
        $r = $t | Where-Object { $_.RowKey -eq $quickStartSampleName }
        if ($null -eq $r) {
            # Next, try against the new, reorganized quickstarts, e.g. application-workloads@active-directory@active-directory-new-domain
            # In this case, we match without the level, and must match the full leaf name
            Write-Host $sampleShortName
            $r = $t | Where-Object { $_.RowKey -like "*@" + $sampleShortName }
            if ($r -and ($r.RowKey -is [string])) {
                $quickStartSampleName = $r.RowKey.Replace("@", "/")
                $quickStartMoved = $true
            }
        }

        if ($null -eq $r) {
            # No match found with quickstarts            

            $row = [PSCustomObject]@{
                Name               = $bicepSampleName
                Status             = ""
                IsBicepQuickStart  = ""
                BicepAuthor        = ""
                QuickStartAuthor   = ""
                #BicepPath          = $bicepFolder
                BestPracticeResult = ""
                #FairfaxDeployment  = ""
                PublicDeployment   = ""
                QuickStartUri      = ""
                BicepUri           = ""
                QuickStartMoved    = ""
            } 
        }
        else {
            if ($r -is [array]) {
                throw "Found multiple matches for $bicepSampleName"
            }
            if (!($r.RowKey -is [string])) {
                throw "RowKey $r.RowKey is not a string"
            }

            # It matches a single quick-start entry in the table
            $BestPracticeResultOk = $r.BestPracticeResult -eq "PASS"
            #$FairfaxDeploymentOk = $r.FairfaxDeployment -ne "FAIL"
            $PublicDeploymentOk = $r.PublicDeployment -ne "FAIL"
            $IsBicepQuickStart = $r.BicepVersion -gt ""
            $Failed = @(($BestPracticeResultOk ? "" : "Best Practices"), ($PublicDeploymentOk ? "" : "Public deployment"))
            | Where-Object { $_ -ne "" }
            $ReadyToConvert = $BestPracticeResultOk -and $PublicDeploymentOk
            if (!$ReadyToConvert -and !$Failed) {
                throw "Quickstart sample not ready to convert, but didn't find what failed"
            }
            $Status = $IsBicepQuickStart ? "DONE" : $ReadyToConvert ? "CONVERT" : "Failed: $($failed | Join-String -Separator ', ')"

            $row = [PSCustomObject]@{
                Name               = $bicepSampleName
                Status             = $Status
                IsBicepQuickStart  = $IsBicepQuickStart
                BicepAuthor        = $sampleAuthor
                QuickStartAuthor   = $r.GitHubUserName
                #BicepPath          = $bicepFolder
                BestPracticeResult = $r.BestPracticeResult
                #FairfaxDeployment  = $r.FairfaxDeployment
                PublicDeployment   = $r.PublicDeployment
                QuickStartUri      = "https://github.com/Azure/azure-quickstart-templates/tree/master/$quickStartSampleName"
                BicepUri           = "https://github.com/Azure/bicep/tree/main/$bicepFolder"
                QuickStartMoved    = $quickStartMoved
            }
        }

        $outputRows += $row
        Write-Output $row | fl * 
    }
}
finally {
    Set-Location $currentFolder
}

$outputCsv = ([io.path]::ChangeExtension($OutputFilename,"csv"))
$outputRows | Export-Csv $outputCsv
Write-Host "Wrote data to $outputCsv"

# Need to do `install-module importexcel`
$outputXls = ([io.path]::ChangeExtension($OutputFilename,"xls"))
$outputRows | Export-Excel $outputXls
Write-Host "Wrote data to $outputXls"

& $outputXls
