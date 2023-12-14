// Welcome to my (overly) complicated module

metadata owner = 'github.com/StephenWeatherford'
metadata name = 'complicated source example'
metadata description = '''Azure Storage is a cloud-based storage service offered by Microsoft that provides highly scalable and durable storage for data and applications. Storage Accounts are the fundamental storage entity in Azure Storage and can be used to store data objects such as blobs, files, queues, tables, and disks.
This Bicep module allows users to create or use existing Storage Accounts with options to control redundancy, access, and security settings. Zone-redundancy allows data to be stored across multiple Availability Zones, increasing availability and durability. Virtual network rules can be used to restrict or allow network traffic to and from the Storage Account. Encryption and TLS settings can be configured to ensure data security.
The module supports both blob and file services, allowing users to store and retrieve unstructured data and files. The output of the module is the ID of the created or existing Storage Account, which can be used in other Azure resource deployments.'''

/*

Example publishing:

  ~/repos/bicep/src/Bicep.Cli/bin/Debug/net7.0/bicep publish ~/repos/template-examples/bicep/modules/complicated/my\ complicated\ module.bicep --target br:sawbicep.azurecr.io/demo/complicated:v1
  Publish-AzBicepModule -FilePath "$HOME/repos/template-examples/bicep/modules/complicated/my complicated module.bicep" -Target br:sawbicep.azurecr.io/demo/complicated:v1-pwsh-ws -WithSource -Verbose

*/

/*

 Demo Setup:

//v23
  bicep publish ~/repos/template-examples/bicep/modules/complicated/my\ complicated\ module.bicep --target br:sawbicep.azurecr.io/demo/complicated:v23-1 --force
  bicep publish ~/repos/template-examples/bicep/modules/complicated/my\ complicated\ module.bicep --target br:sawbicep.azurecr.io/demo/complicated:v23-2 --with-source --force

  ~/repos/bicep/src/Bicep.Cli/bin/Debug/net7.0/bicep publish ~/repos/template-examples/bicep/modules/complicated/my\ complicated\ module.bicep --target br:sawbicep.azurecr.io/demo/complicated:v1 --force
  ~/repos/bicep/src/Bicep.Cli/bin/Debug/net7.0/bicep publish ~/repos/template-examples/bicep/modules/complicated/my\ complicated\ module.bicep --target br:sawbicep.azurecr.io/demo/complicated:v2 --with-source --force

*/


output greeting string = m1.outputs.greeting

module m1 'br/public:samples/hello-world:1.0.2' = {
  name: 'm1'
  params: {
    name: 'me myself'
  }
}

@minLength(3)
@maxLength(11)
param storagePrefix string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'
param location string

var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

// Resources

resource stg 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

output storageEndpoint object = stg.properties.primaryEndpoints

// Linter issues

resource oldStorage1 'Microsoft.Storage/storageAccounts@2015-06-15' = {
  name: 'oldStorage1'
#disable-next-line no-hardcoded-location
  location: 'westus3'
}

resource oldStorage2 'Microsoft.Storage/storageAccounts@2015-06-15' = {
  name: 'oldStorage2'
  // This is disabled through bicepconfig.json
  location: 'westus3'
}

// Public modules - fully qualified

module public1FQ 'br:mcr.microsoft.com/bicep/app/app-configuration:1.0.1' = {
  name: 'public1FQ'  
}

module public2FQ 'br:mcr.microsoft.com/bicep/storage/storage-account:1.0.1' = {
  name: 'public2FQ'
  params: {
    location: 'westus3'
  }
}

// Public modules - using default alias

module public1PublicAlias 'br/public:app/app-configuration:1.0.1' = {
  name: 'public1PublicAlias'  
}

module public2PublicAlias 'br/public:storage/storage-account:1.0.1' = {
  name: 'public2PublicAlias'
  params: {
    location: 'westus3'
  }
}

// Public modules - using private alias

module public1PrivateAlias 'br/privatebicep:app/app-configuration:1.0.1' = {
  name: 'public1PrivateAlias'
}

module public2PrivateAlias 'br/privatebicep:storage/storage-account:1.0.1' = {
  name: 'public2PrivateAlias'
  params: {
    location: 'westus3'
  }
}

// Template specs

module tsModule 'ts:e5ef2b13-6478-4887-ad57-1aa6b9475040/sawbicep/storageSpec:1.0a' = {
  name: 'tsModule'
  params: {
    loc: 'westus3'
  }
}

module tsModule2 'ts/saw:storageSpec:2.0a' = {
  name: 'tsModule2'
  params: {
    loc: 'westus3'
  }
}

// Local modules (only relative path are allowed)

module m5 'modules/main.bicep' = {
  name: 'm5'
}

module relativePath '../simpleModule/storageAccount.bicep' = {
  name: 'relative path module'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
}

// loadcontent

output myscript string = loadTextContent('files/my script.ps1')

// loadcontent

resource virtualMachine 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: 'name'
  location: location
}

resource windowsVMExtensions 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  parent: virtualMachine
  name: 'name'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'fileUris'
      ]
    }
    protectedSettings: {
      commandToExecute: loadTextContent('files/my script.ps1')
    }
  }
}
