param vNetAddress string = '192.168.1.0/24'
param subnetPrefixLength int = 29

resource vNet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: 'MYVNET'
  location: 'westus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNetAddress
      ]
    }
    subnets: [
      {
        name: 'MYSUBNET'
        properties: {
          addressPrefix: cidrSubnet(vNetAddress, subnetPrefixLength, 0)
        }
      }
    ]
  }
}

module virtualMachineScaleSet 'br/public:avm/res/compute/virtual-machine-scale-set:0.4.0' = {
  name: 'virtualMachineScaleSetDeployment'
  params: {
    // Required parameters
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: 'cvmsswinmin001'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              publicIPAddressConfiguration: {
                name: 'pip-cvmsswinmin'
              }
              subnet: {
                //id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'myVNet', 'mySubnet') // vNet::sn.id
                id: vNet.properties.subnets[0].id
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    skuName: 'Standard_B12ms'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    location: 'westus3'
  }

  //dependsOn: [ vNet, vNet::sn ]
}

//output a string = vNet::sn.id
// resourceId('Microsoft.Network/virtualNetworks/subnets', 'myVNet', 'mySubnet')
///subscriptions/e5ef2b13-6478-4887-ad57-1aa6b9475040/resourceGroups/deleteme2/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet
///subscriptions/e5ef2b13-6478-4887-ad57-1aa6b9475040/resourceGroups/DELETEME2/providers/Microsoft.Network/virtualNetworks/MYVNET not found.",

//          /subscriptions/e5ef2b13-6478-4887-ad57-1aa6b9475040/resourceGroups/deleteme2/providers/Microsoft.Network/virtualNetworks/MYVNET
// Resource /subscriptions/e5ef2b13-6478-4887-ad57-1aa6b9475040/resourceGroups/DELETEME2/providers/Microsoft.Network/virtualNetworks/MYVNET not found
//          /subscriptions/e5ef2b13-6478-4887-ad57-1aa6b9475040/resourceGroups/deleteme2/providers/Microsoft.Network/virtualNetworks/MYVNET/subnets/MYSUBNET
