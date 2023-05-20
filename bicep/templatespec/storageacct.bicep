/*

az ts create \
  --name storageSpec \
  --version "2.0a" \
  --resource-group sawbicep \
  --location "westus2" \
  --template-file "./storageacct.bicep"

az ts list

az ts show \
    --name storageSpec \
    --resource-group sawbicep \
    --version "1.0a"

*/

metadata description = 'my template spec description storagespec v2'

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Premium_LRS'
])
param storageAccountType string = 'Standard_LRS'
var prefix = 'stephwe'
param loc string = resourceGroup().location

resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: '${prefix}${uniqueString(resourceGroup().id)}'
  location: loc
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
}
