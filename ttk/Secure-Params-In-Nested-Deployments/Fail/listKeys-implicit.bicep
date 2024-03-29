resource nested 'Microsoft.Resources/deployments@2021-04-01' = {
  name: 'nested'
  properties: {
    mode: 'Complete'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      variables: {}
      resources: [
        {
          name: 'outerImplicit'
          type: 'Microsoft.Network/networkSecurityGroups'
          apiVersion: '2019-11-01'
          location: '[resourceGroup().location]'
          properties: {
            securityRules: [
              {
                name: 'outerImplicit'
                properties: {
                  description: '[format(\'{0}\', listKeys(\'someResourceId\', \'2020-01-01\'))]'
                  protocol: 'Tcp'
                  sourcePortRange: '*'
                  destinationPortRange: '*'
                  sourceAddressPrefix: '*'
                  destinationAddressPrefix: '*'
                  access: 'Allow'
                  priority: 100
                  direction: 'Inbound'
                }
              }
            ]
          }
        }
      ]
    }
  }
}
