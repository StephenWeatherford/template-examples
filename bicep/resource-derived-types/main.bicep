// resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
// name: 'nsg'
// location: 'westus'
// properties: {
// securityRules: [{
// id: 'id1'
// name: 'name1'
// type: 'type1'
// properties: {
// access: 'Allow'
// direction: 'Inbound'
// priority: 4096
// protocol: 'Tcp'
// }
// }]
// }
// }

// param p resource<'Microsoft.Compute/virtualMachines@2020-12-01'>

// type t = resource<'Microsoft.Compute/virtualMachines/extensions@2020-12-01'>.parent
// type t2 = resource<'Microsoft.Compute/virtualMachines/extensions@2020-12-01'>.parent
// type resourceDerived2 = resource<'Microsoft.Compute/virtualMachines/extensions@2019-12-01'>.properties

// type resourceDerived = resource<'Microsoft.Compute/virtualMachines/extensions@2019-12-01'>.properties

type resourceDerived = resource<'Microsoft.Compute/virtualMachines/extensions@2019-12-01'>.properties.settings

param location string

var uniqueStorageName = abc(resourceGroup().id)

func abc(resourceId string) string => string(resourceId)

resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  tags: {
    displayName: 'storageaccount'
  }
  name: uniqueStorageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

output storageEndpoint object = stg.properties.primaryEndpoints

type medium = {
  autoUpgradeMinorVersion: bool?
  forceUpdateTag: string?
  instanceView: {
    name: string?
    statuses: {
      code: string?
      displayStatus: string?
      level: ('Error' | 'Info' | 'Warning')?
      message: string?
      time: string?
    }[]?
    substatuses: {
      code: string?
      displayStatus: string?
      level: ('Error' | 'Info' | 'Warning')?
      message: string?
      time: string?
    }[]?
    type: string?
    typeHandlerVersion: string?
  }?
  protectedSettings: object? /* any */
  publisher: string?
  settings: object? /* any */
  type: string?
  typeHandlerVersion: string?
}?

resource testResource2 'Microsoft.Network/applicationGateways@2020-11-01' = {
  name: 'name'
  location: location
  properties: {
    sku: {
      name: 'Standard_Small'
      tier: 'Standard'
      capacity: 1
    }
    gatewayIPConfigurations: [
      {
        name: 'name'
        properties: {
          subnet: {
            id: 'id'
          }
        }
      }
    ]
  }
}

type medium2 = {
  asserts: object
  dependsOn: (object /* module[] | (resource | module) | resource[] */)[]
  eTag: string
  extendedLocation: { name: string?, type: (string /* 'EdgeZone' | string */)? }?
  identity: {
    type: ('None' | 'SystemAssigned' | 'SystemAssigned, UserAssigned' | 'UserAssigned')?
    userAssignedIdentities: object?
  }?
  kind: string
  location: string
  managedBy: string
  managedByExtended: string[]
  name: string
  plan: { name: string?, product: string?, promotionCode: string?, publisher: string? }?
  properties: {
    additionalCapabilities: { ultraSSDEnabled: bool? }?
    availabilitySet: { id: string? }?
    billingProfile: { maxPrice: int? }?
    diagnosticsProfile: { bootDiagnostics: { enabled: bool?, storageUri: string? }? }?
    evictionPolicy: (string /* 'Deallocate' | 'Delete' | string */)?
    extensionsTimeBudget: string?
    hardwareProfile: {
      vmSize: (string /* 'Basic_A0' | 'Basic_A1' | 'Basic_A2' | 'Basic_A3' | 'Basic_A4' | 'Standard_A0' | 'Standard_A1' | 'Standard_A10' | 'Standard_A11' | 'Standard_A1_v2' | 'Standard_A2' | 'Standard_A2_v2' | 'Standard_A2m_v2' | 'Standard_A3' | 'Standard_A4' | 'Standard_A4_v2' | 'Standard_A4m_v2' | 'Standard_A5' | 'Standard_A6' | 'Standard_A7' | 'Standard_A8' | 'Standard_A8_v2' | 'Standard_A8m_v2' | 'Standard_A9' | 'Standard_B1ms' | 'Standard_B1s' | 'Standard_B2ms' | 'Standard_B2s' | 'Standard_B4ms' | 'Standard_B8ms' | 'Standard_D1' | 'Standard_D11' | 'Standard_D11_v2' | 'Standard_D12' | 'Standard_D12_v2' | 'Standard_D13' | 'Standard_D13_v2' | 'Standard_D14' | 'Standard_D14_v2' | 'Standard_D15_v2' | 'Standard_D16_v3' | 'Standard_D16s_v3' | 'Standard_D1_v2' | 'Standard_D2' | 'Standard_D2_v2' | 'Standard_D2_v3' | 'Standard_D2s_v3' | 'Standard_D3' | 'Standard_D32_v3' | 'Standard_D32s_v3' | 'Standard_D3_v2' | 'Standard_D4' | 'Standard_D4_v2' | 'Standard_D4_v3' | 'Standard_D4s_v3' | 'Standard_D5_v2' | 'Standard_D64_v3' | 'Standard_D64s_v3' | 'Standard_D8_v3' | 'Standard_D8s_v3' | 'Standard_DS1' | 'Standard_DS11' | 'Standard_DS11_v2' | 'Standard_DS12' | 'Standard_DS12_v2' | 'Standard_DS13' | 'Standard_DS13-2_v2' | 'Standard_DS13-4_v2' | 'Standard_DS13_v2' | 'Standard_DS14' | 'Standard_DS14-4_v2' | 'Standard_DS14-8_v2' | 'Standard_DS14_v2' | 'Standard_DS15_v2' | 'Standard_DS1_v2' | 'Standard_DS2' | 'Standard_DS2_v2' | 'Standard_DS3' | 'Standard_DS3_v2' | 'Standard_DS4' | 'Standard_DS4_v2' | 'Standard_DS5_v2' | 'Standard_E16_v3' | 'Standard_E16s_v3' | 'Standard_E2_v3' | 'Standard_E2s_v3' | 'Standard_E32-16_v3' | 'Standard_E32-8s_v3' | 'Standard_E32_v3' | 'Standard_E32s_v3' | 'Standard_E4_v3' | 'Standard_E4s_v3' | 'Standard_E64-16s_v3' | 'Standard_E64-32s_v3' | 'Standard_E64_v3' | 'Standard_E64s_v3' | 'Standard_E8_v3' | 'Standard_E8s_v3' | 'Standard_F1' | 'Standard_F16' | 'Standard_F16s' | 'Standard_F16s_v2' | 'Standard_F1s' | 'Standard_F2' | 'Standard_F2s' | 'Standard_F2s_v2' | 'Standard_F32s_v2' | 'Standard_F4' | 'Standard_F4s' | 'Standard_F4s_v2' | 'Standard_F64s_v2' | 'Standard_F72s_v2' | 'Standard_F8' | 'Standard_F8s' | 'Standard_F8s_v2' | 'Standard_G1' | 'Standard_G2' | 'Standard_G3' | 'Standard_G4' | 'Standard_G5' | 'Standard_GS1' | 'Standard_GS2' | 'Standard_GS3' | 'Standard_GS4' | 'Standard_GS4-4' | 'Standard_GS4-8' | 'Standard_GS5' | 'Standard_GS5-16' | 'Standard_GS5-8' | 'Standard_H16' | 'Standard_H16m' | 'Standard_H16mr' | 'Standard_H16r' | 'Standard_H8' | 'Standard_H8m' | 'Standard_L16s' | 'Standard_L32s' | 'Standard_L4s' | 'Standard_L8s' | 'Standard_M128-32ms' | 'Standard_M128-64ms' | 'Standard_M128ms' | 'Standard_M128s' | 'Standard_M64-16ms' | 'Standard_M64-32ms' | 'Standard_M64ms' | 'Standard_M64s' | 'Standard_NC12' | 'Standard_NC12s_v2' | 'Standard_NC12s_v3' | 'Standard_NC24' | 'Standard_NC24r' | 'Standard_NC24rs_v2' | 'Standard_NC24rs_v3' | 'Standard_NC24s_v2' | 'Standard_NC24s_v3' | 'Standard_NC6' | 'Standard_NC6s_v2' | 'Standard_NC6s_v3' | 'Standard_ND12s' | 'Standard_ND24rs' | 'Standard_ND24s' | 'Standard_ND6s' | 'Standard_NV12' | 'Standard_NV24' | 'Standard_NV6' | string */)?
    }?
    host: { id: string? }?
    hostGroup: { id: string? }?
    licenseType: string?
    networkProfile: { networkInterfaces: { id: string?, properties: { primary: bool? }? }[]? }?
    osProfile: {
      adminPassword: string?
      adminUsername: string?
      allowExtensionOperations: bool?
      computerName: string?
      customData: string?
      linuxConfiguration: {
        disablePasswordAuthentication: bool?
        patchSettings: { patchMode: (string /* 'AutomaticByPlatform' | 'ImageDefault' | string */)? }?
        provisionVMAgent: bool?
        ssh: { publicKeys: { keyData: string?, path: string? }[]? }?
      }?
      requireGuestProvisionSignal: bool?
      secrets: {
        sourceVault: { id: string? }?
        vaultCertificates: { certificateStore: string?, certificateUrl: string? }[]?
      }[]?
      windowsConfiguration: {
        additionalUnattendContent: {
          componentName: string?
          content: string?
          passName: string?
          settingName: ('AutoLogon' | 'FirstLogonCommands')?
        }[]?
        enableAutomaticUpdates: bool?
        patchSettings: {
          enableHotpatching: bool?
          patchMode: (string /* 'AutomaticByOS' | 'AutomaticByPlatform' | 'Manual' | string */)?
        }?
        provisionVMAgent: bool?
        timeZone: string?
        winRM: { listeners: { certificateUrl: string?, protocol: ('Http' | 'Https')? }[]? }?
      }?
    }?
    platformFaultDomain: int?
    priority: (string /* 'Low' | 'Regular' | 'Spot' | string */)?
    proximityPlacementGroup: { id: string? }?
    securityProfile: {
      encryptionAtHost: bool?
      securityType: (string /* 'TrustedLaunch' | string */)?
      uefiSettings: { secureBootEnabled: bool?, vTpmEnabled: bool? }?
    }?
    storageProfile: {
      dataDisks: {
        caching: ('None' | 'ReadOnly' | 'ReadWrite')?
        createOption: string /* 'Attach' | 'Empty' | 'FromImage' | string */
        detachOption: (string /* 'ForceDetach' | string */)?
        diskSizeGB: int?
        image: { uri: string? }?
        lun: int
        managedDisk: {
          diskEncryptionSet: { id: string? }?
          id: string?
          storageAccountType: (string /* 'Premium_LRS' | 'Premium_ZRS' | 'StandardSSD_LRS' | 'StandardSSD_ZRS' | 'Standard_LRS' | 'UltraSSD_LRS' | string */)?
        }?
        name: string?
        toBeDetached: bool?
        vhd: { uri: string? }?
        writeAcceleratorEnabled: bool?
      }[]?
      imageReference: { id: string?, offer: string?, publisher: string?, sku: string?, version: string? }?
      osDisk: {
        caching: ('None' | 'ReadOnly' | 'ReadWrite')?
        createOption: string /* 'Attach' | 'Empty' | 'FromImage' | string */
        diffDiskSettings: {
          option: (string /* 'Local' | string */)?
          placement: (string /* 'CacheDisk' | 'ResourceDisk' | string */)?
        }?
        diskSizeGB: int?
        encryptionSettings: {
          diskEncryptionKey: { secretUrl: string, sourceVault: { id: string? } }?
          enabled: bool?
          keyEncryptionKey: { keyUrl: string, sourceVault: { id: string? } }?
        }?
        image: { uri: string? }?
        managedDisk: {
          diskEncryptionSet: { id: string? }?
          id: string?
          storageAccountType: (string /* 'Premium_LRS' | 'Premium_ZRS' | 'StandardSSD_LRS' | 'StandardSSD_ZRS' | 'Standard_LRS' | 'UltraSSD_LRS' | string */)?
        }?
        name: string?
        osType: ('Linux' | 'Windows')?
        vhd: { uri: string? }?
        writeAcceleratorEnabled: bool?
      }?
    }?
    virtualMachineScaleSet: { id: string? }?
  }?
  scale: { capacity: int, maximum: int, minimum: int }
  sku: { capacity: int, family: string, model: string, name: string, size: string, tier: string }
  tags: object?
  zones: string[]?
}

type resourceDerived2 = resource<'Microsoft.Network/applicationGateways@2020-11-01'>.identity.userAssignedIdentities

resource testResource 'Microsoft.Network/applicationGateways@2020-11-01' = {
  properties: {
    urlPathMaps: [
      {
        properties: {
          pathRules: [
            {
              name: 'name'
              properties: {
                paths: [
                  'path'
                ]
                backendAddressPool: {
                  id: 'id'
                }
              }
            }
          ]
        }
      }
    ]
  }
}


resource testResource 'Microsoft.Compute/virtualMachines/extensions@2019-12-01' = [for (item, index) in mylist: {
    name: 'cse-windows/extension'
    location: 'location'
    properties: {
    }
  }
]

@description('Properties of the network security group.')
param properties resource<'Microsoft.Network/networkSecurityGroups@2023-09-01'>.properties = {
  securityRules: [
    {
      id: 'id1'
      name: 'name1'
      type: 'type1'
      properties: {
        access: 'Allow'
        direction: 'Inbound'
        priority: 4096
        protocol: 'Tcp'
      }
    }
  ]
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg'
  location: 'westus'
  properties: properties
}


resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg'
  location: 'westus'
  properties: {
    securityRules: [{
      id: 'id1'
      name: 'name1'
      type: 'type1'
      properties: {
        access: 'Allow'
        direction: 'Inbound'
        priority: 4096
        protocol: 'Tcp'
      }
    }]
  }
}


param _artifactsLocation string
param  _artifactsLocationSasToken string

param properties resource<'Microsoft.Compute/virtualMachines/extensions@2019-12-01'> = {
  // Entire properties object selected
  publisher: 'Microsoft.Compute'
  type: 'CustomScriptExtension'
  typeHandlerVersion: '1.8'
  autoUpgradeMinorVersion: true
  settings: {
    fileUris: [
      uri(_artifactsLocation, 'writeblob.ps1${_artifactsLocationSasToken}')
    ]
    commandToExecute: commandToExecute
  }
}

resource resourceWithProperties 'Microsoft.Compute/virtualMachines/extensions@2019-12-01' = if (isWindowsOS && provisionExtensions) {
    parent: vmName_resource
    name: 'cse-windows'
    location: location
    properties: properties
}


resource r 'Microsoft.Resources/tags@2024-07-01' = {
  name: 'default'
  properties: {
    tags: {
      'a': 'b'
    }
  }
}
