/*
    [-] Secure Params In Nested Deployments (27 ms)
        Microsoft.Resources/deployments/nested is an outer scope nested deployment that contains a secureString type parameter: "stgAccountName"
*/
@secure()
#disable-next-line secure-parameter-default
param stgAccountName string

resource nested 'Microsoft.Resources/deployments@2021-04-01' = {
    name: 'nested'
    properties: {
        mode: 'Incremental'
        template: {
            '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
            contentVersion: '1.0.0.0'
            resources: [
                {
                    name: stgAccountName
                    type: 'Microsoft.Storage/storageAccounts'
                    apiVersion: '2021-04-01'
                    #disable-next-line no-loc-expr-outside-params
                    location: resourceGroup().location
                    kind: 'StorageV2'
                    sku: {
                        name: 'Premium_LRS'
                        tier: 'Premium'
                    }
                }
            ]
        }
    }
}
