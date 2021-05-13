param lokation string

resource storageaccount1 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'storageaccount1'
  location: lokation
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
    tier: 'Premium'
  }
}