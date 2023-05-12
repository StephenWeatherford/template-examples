@description('description')
param existingVirtualNetworkName string

@description('description')
param existingSubnetName string

@description('description')
param builtInRoleType int

@description('description')
param existingServicePrincipalObjectId string

var builtInRole = []
var vnetSubnetId = ''

resource existingVirtualNetworkName_existingSubnetName_Microsoft_Authorization_id_name 'Microsoft.Network/virtualNetworks/subnets/providers/roleAssignments@2020-04-01-preview' = {
  name: '${existingVirtualNetworkName}/${existingSubnetName}/Microsoft.Authorization/${guid(resourceGroup().id, deployment().name)}'
  properties: {
    roleDefinitionId: builtInRole[builtInRoleType]
    principalId: existingServicePrincipalObjectId
    scope: vnetSubnetId
  }
}


@description('The principal to assign the role to')
param principalId string

@allowed([
  'Owner'
  'Contributor'
  'Reader'
])
@description('Built-in role to assign')
param builtInRoleType string

param location string = resourceGroup().location

var role = {
  Owner: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7'
}
var uniqueStorageName = 'storage${uniqueString(resourceGroup().id)}'

resource demoStorageAcct 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
  properties: {}
}

resource roleAssignStorage 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(demoStorageAcct.id, principalId, role[builtInRoleType])
  properties: {
    roleDefinitionId: role[builtInRoleType]
    principalId: principalId
  }
  scope: demoStorageAcct
}