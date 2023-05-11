resource publicIPAddress1 'Microsoft.Network/publicIPAddresses@[concat(\'2020\', \'01-01\')]' = {
  name: 'publicIPAddress1'
  location: resourceGroup().location
  tags: {
    displayName: 'publicIPAddress1'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}