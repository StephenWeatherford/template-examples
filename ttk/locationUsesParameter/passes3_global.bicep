param location string = 'global'

resource storageaccount1 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'storageaccount1'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
    tier: 'Premium'
  }
}