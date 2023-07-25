metadata description = 'description'

@minLength(3)
@maxLength(11)
@sys.description('hello')
param namePrefix string
param location string = resourceGroup().location

module stgModule './storageAccount.bicep' = {
  name: 'storageDeploy'
  params: {
    storagePrefix: namePrefix
    location: location
  }
}

output storageEndpoint object = stgModule.outputs.storageEndpoint
