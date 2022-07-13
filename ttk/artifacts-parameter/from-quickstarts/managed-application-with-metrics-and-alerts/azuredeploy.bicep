param location string = resourceGroup().location

@sys.description('hello')
param applicationName string = 'applicationWithMetricsAndAlerts'

@sys.description('Storage account name')
param storageAccountName string
param storageAccountType string = 'Standard_LRS'

@sys.description('The base URI where artifacts required by this template are located. When the template is deployed using the accompanying scripts, a private location in the subscription will be used and this value will be automatically generated.')
param _artifactsLocation string = deployment().properties.templateLink.uri

@sys.description('The sasToken required to access _artifactsLocation.  When the template is deployed using the accompanying scripts, a sasToken will be automatically generated.')
@secure()
param _artifactsLocationSasToken string = ''

var applicationDefinitionName_var = '${applicationName}_definition'
var lockLevel = 'None'
var description = 'Sample managed application definition with metrics and alerts'
var displayName = 'Sample managed application definition with metrics and alerts'
var packageFileUri = uri(_artifactsLocation, 'artifacts/ManagedAppZip/pkg.zip${_artifactsLocationSasToken}')
var managedResourceGroupId = '${subscription().id}/resourceGroups/${applicationName}_managed'
var applicationDefinitionResourceId = applicationDefinitionName.id

resource applicationDefinitionName 'Microsoft.Solutions/applicationDefinitions@2019-07-01' = {
  name: applicationDefinitionName_var
  location: location
  properties: {
    lockLevel: lockLevel
    description: description
    displayName: displayName
    packageFileUri: packageFileUri
  }
}

resource applicationName_resource 'Microsoft.Solutions/applications@2019-07-01' = {
  name: applicationName
  location: location
  kind: 'ServiceCatalog'
  properties: {
    managedResourceGroupId: managedResourceGroupId
    applicationDefinitionId: applicationDefinitionResourceId
    parameters: {
      location: {
        value: location
      }
      storageAccountName: {
        value: storageAccountName
      }
      storageAccountType: {
        value: storageAccountType
      }
    }
  }
  dependsOn: [
    #disable-next-line no-unnecessary-dependson
    applicationDefinitionName
  ]
}
