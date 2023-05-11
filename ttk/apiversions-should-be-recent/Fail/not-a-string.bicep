resource publicIPAddress1 'Microsoft.Network/publicIPAddresses@True' = {
  name: 'publicIPAddress1'
  location: 'westus'
  tags: {
    displayName: 'publicIPAddress1'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}
