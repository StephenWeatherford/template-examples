var storageBlobDataReaderRoleDefinitionId = 'value'
var roleAssignmentName_var = 'value'
var storageAccountName = 'value'
var dataShareAccountName = 'value'

resource roleAssignmentName 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  scope: 'Microsoft.Storage/storageAccounts/${storageAccountName}'
  name: roleAssignmentName_var
  properties: {
    roleDefinitionId: storageBlobDataReaderRoleDefinitionId
    principalId: reference(resourceId('Microsoft.DataShare/accounts', dataShareAccountName), '2019-11-01', 'Full').identity.principalId
  }
}
