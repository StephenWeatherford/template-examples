// ~/repos/bicep/src/Bicep.Cli/bin/Debug/net7.0/bicep publish '/Users/stephenweatherford/repos/template-examples/bicep/modules/spaces/my main bicep file.bicep' --target br:sawbicep.azurecr.io/spaces:v1

metadata description = 'description'

@minLength(3)
@maxLength(11)
@sys.description('hello')
param namePrefix string
param location string = resourceGroup().location

module stgModule './storage Account.bicep' = {
  name: 'storageDeploy'
  params: {
    storagePrefix: namePrefix
    location: location
  }
}

module stgAccount 'storage Account json.json' = {
  name: 'stgAccount json'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe2'
  }
}
output storageEndpoint object = stgModule.outputs.storageEndpoint
