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



// Public modules

module appConfig 'br/public:app/app-configuration:1.0.1' = {
  name: 'appConfig'  
}

module m6 'br/public:app/app-configuration:1.0.1' = {
  name: 'm6'
}

module m7 'br/public:app/dapr-containerapps-environment:1.2.2' = {
  name: 'm7'
  params: {
    daprComponentType: 'pubsub.azure.servicebus'
    location: 'westus2'
    nameseed: 'stephwe'
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

// Relative paths

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

// Absolute file paths - not allowed
/*
module absolutePath1 '/Users/stephenweatherford/repos/template-examples/bicep/modules/templatespec/storageacct.bicep' = {
  name: 'relative path module'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
}
*/

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

// module m 'br/saw:misc/deep-stuff/and-deeper/and-deeper/just-right/modules/storage:v1' = {
//   name: 'm'
//   params: {
//     location: 'westus'
//     storagePrefix: 'saw'
//   }
// }

// module m2 'br/saw:misc/deep-stuff/and-deeper/and-deeper/just-right/modules/storage:v2' = {
//   name: 'm2'
//   params: {}
// }

// module m3 'br/saw:misc/deep-stuff/and-deeper/and-deeper/just-right/modules/storage:v3' = {
//   name: 'm3'
//   params: {}
// }

