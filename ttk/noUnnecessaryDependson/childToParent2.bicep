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

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'name'
  location: location
  sku: {
    name: 'F1'
    capacity: 1
  }
  dependsOn: [
    VNet1
  ]
}
