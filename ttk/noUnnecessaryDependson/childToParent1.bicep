param location string

resource VNet1 'Microsoft.Network/virtualNetworks@2018-10-01' = {
  name: 'VNet1'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource VNet1_Subnet1 'Microsoft.Network/virtualNetworks/subnets@2018-10-01' = {
  name: '${VNet1.name}/Subnet1'
  properties: {
    addressPrefix: '10.0.0.0/24'
  }
  dependsOn: [
    VNet1 // Reference to child not needed
  ]
}
