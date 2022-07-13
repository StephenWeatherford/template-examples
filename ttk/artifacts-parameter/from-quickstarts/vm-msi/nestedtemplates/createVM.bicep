@description('The base URI where artifacts required by this template are located. When the template is deployed using the accompanying scripts, a private location in the subscription will be used and this value will be automatically generated.')
param _artifactsLocation string

@description('The sasToken required to access _artifactsLocation.')
@secure()
param _artifactsLocationSasToken string = ''

@description('OS Admin password or SSH Key depending on value of authentication type')
@secure()
param adminPasswordOrKey string

@description('Username for the Virtual Machine.')
param adminUsername string

@description('Authentication type')
@allowed([
  'password'
  'sshPublicKey'
])
param authenticationType string = 'password'

@description('The Docker image to rin the azure CLI from')
param azureCLI2DockerImage string = 'azuresdk/azure-cli-python:latest'
param containerName string

@description('The Location For the resources')
param location string

@description('The nsg id for the VM')
param nsgId string

@description('OS for the VM, this is the offer and SKU concatenated with underscores and then mapped to a variable')
param operatingSystem string

@description('determines whether to provision the extensions')
param provisionExtensions bool

@description('The storage account Id for boot diagnostics for the VMs')
param storageAccountId string

@description('The name of the storage account for the blob copy')
param storageAccountName string
param subnetRef string

@description('The size of the VM to create')
param vmSize string = 'Standard_D2s_v3'

@description('The name of the vm')
param vmName string

var isWindowsOS = bool(contains(toLower(imageReference[operatingSystem].offer), 'windows'))
var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminUsername}/.ssh/authorized_keys'
        keyData: adminPasswordOrKey
      }
    ]
  }
}
var imageReference = {
  'UbuntuServer_16.04-LTS': {
    publisher: 'Canonical'
    offer: 'UbuntuServer'
    sku: '16.04-LTS'
    version: 'latest'
  }
  'UbuntuServer_18.04-LTS': {
    publisher: 'Canonical'
    offer: 'UbuntuServer'
    sku: '18.04-LTS'
    version: 'latest'
  }
  'WindowsServer_2016-DataCenter': {
    publisher: 'MicrosoftWindowsServer'
    offer: 'WindowsServer'
    sku: '2016-Datacenter'
    version: 'latest'
  }
}
var windowsConfiguration = {
  provisionVmAgent: 'true'
}
var publicIPAddressName_var = 'publicIp'
var nicName_var = 'nic'

resource publicIPAddressName 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: publicIPAddressName_var
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource nicName 'Microsoft.Network/networkInterfaces@2019-11-01' = {
  name: nicName_var
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddressName.id
          }
          subnet: {
            id: subnetRef
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
  }
}

resource vmName_resource 'Microsoft.Compute/virtualMachines@2019-12-01' = {
  name: vmName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
      linuxConfiguration: ((authenticationType == 'password') ? json('null') : linuxConfiguration)
      windowsConfiguration: (isWindowsOS ? windowsConfiguration : json('null'))
    }
    storageProfile: {
      imageReference: imageReference[operatingSystem]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicName.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: reference(storageAccountId, '2018-02-01').primaryEndpoints.blob
      }
    }
  }
}

resource vmName_cse_windows 'Microsoft.Compute/virtualMachines/extensions@2019-12-01' = if (isWindowsOS && provisionExtensions) {
  parent: vmName_resource
  name: 'cse-windows'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.8'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        uri(_artifactsLocation, 'writeblob.ps1${_artifactsLocationSasToken}')
      ]
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File  .\\writeblob.ps1  -SubscriptionId ${subscription().subscriptionId} -TenantId ${subscription().tenantId} -ResourceGroupName ${resourceGroup().name} -StorageAccountName ${storageAccountName} -ContainerName ${containerName} -Verbose'
    }
  }
}

resource vmName_cse_linux 'Microsoft.Compute/virtualMachines/extensions@2019-12-01' = if ((!isWindowsOS) && provisionExtensions) {
  parent: vmName_resource
  name: 'cse-linux'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.0'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        uri(_artifactsLocation, 'scripts/writeblob.sh${_artifactsLocationSasToken}')
        uri(_artifactsLocation, 'scripts/install-and-run-cli-2.sh${_artifactsLocationSasToken}')
      ]
    }
    protectedSettings: {
      commandToExecute: './install-and-run-cli-2.sh -i "${azureCLI2DockerImage}" -a "${storageAccountName}" -c "${containerName}" -r "${resourceGroup().name}"'
    }
  }
}

output principalId string = reference(vmName_resource.id, '2019-12-01', 'Full').identity.principalId
output linuxTest bool = ((!isWindowsOS) && provisionExtensions)
output windowsTest bool = (isWindowsOS && provisionExtensions)
