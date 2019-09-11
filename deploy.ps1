 param (
    [Parameter(Mandatory=$true)][string]$templateFile
 )

#Connect-AzAccount
#Set-AzContext -SubscriptionName
New-AzResourceGroupDeployment -ResourceGroupName deleteme -TemplateFile $templateFile

