param location string
resource storageaccount 'Microsoft.DataMigration/services@2022-03-30-preview' = {
  name: 'name'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
}
