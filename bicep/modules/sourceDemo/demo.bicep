// What is Bicep?
// Bicep is a Domain Specific Language (DSL) for deploying Azure resources declaratively.



@description('Specifies the location for resources.')
param location string = 'westus'

resource virtualMachine1 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: 'vm1'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '16.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: 'vm1'
      adminPassword: 'Password1234!'
    }
  }
}

output vmId string = virtualMachine1.id

// This is a reference to a published (shared) bicep module.
module modKeyvault1 'br/demo:avm/key-vault:v2' = {
  name: 'keyvault1'
  params: {
    name: 'keyname'
  }
}
