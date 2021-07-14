#Requires -Module AzTable

<#

Matches bicep samples in the bicep repo with existing QuickStarts samples

#>

param(
    [string]$ReposRoot = "~/repos",
    # [string]$QuickStartsRepoPath = "~/repos/azure-quickstart-templates",
    [string]$StorageAccountName = "azurequickstartsservice",
    [string]$StorageAccountResourceGroupName = "azure-quickstarts-service-storage",
    [string]$TableName = "QuickStartsMetadataService",
    $ResultDeploymentLastTestDateParameter = "PublicLastTestDate", # sort based on the cloud we're testing (FairfaxLastTestDate or PublicLastTestDate)
    $ResultDeploymentParameter = "PublicDeployment", # PublicDeployment or FairfaxDeployment
    $OutputFilename = "~/Business/bicepsamples-status"
)

$BicepRepoPath = "$ReposRoot/bicep"
$QuickStartRepoPath = "$ReposRoot/azure-quickstart-templates"

$currentFolder = Get-Location
try {
    Import-Module "$PSScriptRoot/ConvertSamples.psm1" -Force
    CheckOut $ReposRoot/bicep main

    $t = GetQuickStartTable
    $conversionsTable = GetBicepConversionsTable

    # # Get all the quickstart samples from disk
    # $ArtifactFilePaths = Get-ChildItem $QuickStartsRepoPath\metadata.json -Recurse -File | ForEach-Object -Process { $_.FullName }
    # Write-Host $ArtifactFilePaths

    # if ($ArtifactFilePaths.Count -eq 0) {
    #     Write-Error "No metadata.json files found in $QuickStartsRepoPath"
    #     throw
    # }

    # Get all the bicep samples
    $BicepTemplateFilePaths = Get-ChildItem "$BicepRepoPath/docs/examples/main.bicep" -Recurse -File | ForEach-Object -Process { $_.FullName }
    Write-Host $BicepTemplateFilePaths

    $outputRows = @()

    # Create a left join of the bicep and quick-start samples (from the table)
    foreach ($bicepPath in $BicepTemplateFilePaths) {
        $folder = split-path $bicepPath -Parent
        $level = split-path (Split-Path $folder -Parent) -Leaf # This is the name of the parent folder ("101", "201", etc.)
        $sampleShortName = Split-Path $folder -Leaf
        $bicepSampleName = "$level/$sampleShortName"
        $bicepRelativeFolder = "docs/examples/$level/$sampleShortName"

        Set-Location (Split-Path -Parent $bicepPath)
        $sampleAuthor = & git log --pretty=format:'%an' $bicepPath | tail -1 # Author who checked in the first version of the example

        # Does the bicep example have the migration readme?
        $bicepExamplePushed = $false
        $exampleReadmeFn = "$folder/README-MOVED.md"
        if (!(Test-Path $exampleReadmeFn)) {
            $exampleReadmeFn = "$folder/README.md"
        }
        if (!(Test-Path $exampleReadmeFn)) {
            $exampleReadmeFn = "$folder/readme.md"
        }
        if (Test-Path $exampleReadmeFn) {
            $exampleReadme = Get-Content $exampleReadmeFn
            if ($exampleReadme -like "*This sample has been moved*") {
                $bicepExamplePushed = $true
            }
        }

        $r, $QuickStartSampleName, $quickStartMoved, $hasQuickStart = FindQuickStartFromBicepExample $BicepSampleName $t $conversionsTable -NoCache

        if ($null -eq $r) {
            # No match found with quickstarts            

            $row = [PSCustomObject]@{
                Totals             = ""
                Name               = $bicepSampleName
                Status             = "Not a QuickStart"
                HasQuickStartPR    = "" 
                HasBicepPR         = ""
                QuickStartPushed   = ""
                bicepExamplePushed = ""
                QuickStartPR       = ""
                BicepPR            = ""
                BicepAuthor        = ""
                QuickStartAuthor   = ""
                #BicepPath          = $bicepFolder
                BestPracticeResult = ""
                #FairfaxDeployment  = ""
                PublicDeployment   = ""
                BicepUri           = ""
                QuickStartUri      = ""
                QuickStartMoved    = ""
            } 
        }
        else {
            # It matches a single quick-start entry in the table
            $BestPracticeResultOk = $r.BestPracticeResult -eq "PASS"
            #$FairfaxDeploymentOk = $r.FairfaxDeployment -ne "FAIL"
            $PublicDeploymentOk = $r.PublicDeployment -ne "FAIL"
            $QuickStartHasBicep = $r.BicepVersion -gt ""
            $Failed = @(($BestPracticeResultOk ? "" : "Best Practices"), ($PublicDeploymentOk ? "" : "Public deployment"))
            | Where-Object { $_ -ne "" }
            $ReadyToConvert = $BestPracticeResultOk -and $PublicDeploymentOk
            if (!$ReadyToConvert -and !$Failed) {
                throw "Quickstart sample not ready to convert, but didn't find what failed"
            }
            if ($QuickStartHasBicep -and $bicepExamplePushed) {
                $Status = "DONE"
            }
            elseif ($QuickStartHasBicep) {
                $Status = "IN PROGRESS: Quickstart converted"
            }
            elseif ($bicepExamplePushed) {
                $Status = "IN PROGRESS: Example converted"
            }
            else {
                $Status = $ReadyToConvert ? "Ready To Convert" : "Failed: $($failed | Join-String -Separator ', ')"
            }

            $row = [PSCustomObject]@{
                Totals             = ""
                Name               = $bicepSampleName
                Status             = $Status
                HasQuickStartPR    = "" # Filled in later
                HasBicepPR         = "" # Filled in later
                QuickStartPushed   = $QuickStartHasBicep ? "TRUE" : ""
                bicepExamplePushed = $bicepExamplePushed ? "TRUE" : ""
                QuickStartPR       = "" # Filled in later
                BicepPR            = "" # Filled in later
                BicepAuthor        = $sampleAuthor
                QuickStartAuthor   = $r.GitHubUserName
                #BicepPath          = $bicepFolder
                BestPracticeResult = $r.BestPracticeResult
                #FairfaxDeployment  = $r.FairfaxDeployment
                PublicDeployment   = $r.PublicDeployment
                BicepUri           = "https://github.com/Azure/bicep/tree/main/$bicepFolder"
                QuickStartUri      = "https://github.com/Azure/azure-quickstart-templates/tree/master/$quickStartSampleName"
                QuickStartMoved    = $quickStartMoved
            }
        }

        $outputRows += $row
        #Write-Output $row | fl * 
    }
}
finally {
    Set-Location $currentFolder
}

$sorted = $outputRows | Sort-Object -Property @{Expression = "Status"; Descending = $false }, "Name"
$statuses = $outputRows | select -Property "Status" -Unique

cd $BicepRepoPath
& gh pr list --label "bicep example migration" -s all | Tee-Object -Variable prs
$prs = $prs -split "`n`r"
foreach ($pr in $prs) {
    if ($pr -match "^([0-9]+).*([0-9][0-9][0-9]/[a-zA-Z0-9-]+)") {
        $bicepPR = $matches[1]
        $bicepSampleName = $matches[2]
        $r = $outputRows | Where-Object { $_.Name -eq $bicepSampleName }
        if (!$r) {
            throw "Could not find bicep sample $bicepSampleName"
        }

        $r.BicepPR = "https://github.com/Azure/bicep/pull/$bicepPR"
        $r.HasBicepPR = "TRUE"

    }
    else {
        throw "Could not parse PR text: $pr"
    }
}

cd $QuickStartRepoPath
& gh pr list --label "bicep example migration" -s all | Tee-Object -Variable prs
$prs = $prs -split "`n`r"
foreach ($pr in $prs) {
    if ($pr -match "^([0-9]+).*([0-9][0-9][0-9]/[a-zA-Z0-9-]+)") {
        $quickStartPR = $matches[1]
        $bicepSampleName = $matches[2]
        $r = $outputRows | Where-Object { $_.Name -eq $bicepSampleName }
        if (!$r) {
            throw "Could not find bicep sample $bicepSampleName"
        }

        $r.QuickStartPR = "https://github.com/Azure/azure-quickstart-templates/pull/$QuickStartPR"
        $r.HasQuickStartPR = "TRUE"
    }
    else {
        throw "Could not parse PR text: $pr"
    }
}

foreach ($status in $statuses) {
    $matching = $outputRows | Where-Object { $_.Status -eq $status.Status }
    #$sorted = @( @{ Totals = "$($status): $($matching.Length)" } ) + $sorted
}
#$sorted = @( @{ Totals = "Total: $($outputRows.Length)" } ) + $sorted

$outputCsv = ([io.path]::ChangeExtension($OutputFilename, "csv"))
$sorted | Export-Csv $outputCsv
Write-Host "Wrote data to $outputCsv"

# Need to do `install-module importexcel` if Export-Excel not found
$outputXls = ([io.path]::ChangeExtension($OutputFilename, "xls"))
$sorted | Export-Excel $outputXls
Write-Host "Wrote data to $outputXls"

& $outputXls
