 param (
    [Parameter(Mandatory=$true)][string]$templateFile,
    [string]$paramsFile
 )

#Connect-AzAccount
#Set-AzContext -SubscriptionName

$rg = Get-AzResourceGroup deleteme -ErrorAction Ignore
if (!$rg) {
   New-AzResourceGroup -Name deleteme -Location westus2
}

if ($paramsFile) {
   New-AzResourceGroupDeployment -ResourceGroupName deleteme -TemplateFile $templateFile -TemplateParameterFile $paramsFile
} else {
   New-AzResourceGroupDeployment -ResourceGroupName deleteme -TemplateFile $templateFile
}
