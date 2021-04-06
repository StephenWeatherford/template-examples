@description('description')
param azureAdminUpn string

var location = 'value'
var autoAccountName = 'value'
var identityName = 'value'
var devOpsProjectName = 'value'
var devOpsName = 'value'
var keyvaultName = 'value'
var artifactsLocation = 'value'

resource createDevopsPipeline 'Microsoft.Resources/deploymentScripts@2019-10-01-preview' = {
  name: 'createDevopsPipeline'
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities/', identityName)}': {}
    }
  }
  properties: {
    forceUpdateTag: '1'
    azCliVersion: '2.0.80'
    arguments: '${devOpsName} ${devOpsProjectName} ${azureAdminUpn} ${keyvaultName}'
    primaryScriptUri: '${artifactsLocation}/ARMRunbookScripts/createDevopsPipeline.sh'
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
  dependsOn: [
    'Microsoft.Automation/automationAccounts/${autoAccountName}/jobs/${autoAccountName}'
  ]
}
