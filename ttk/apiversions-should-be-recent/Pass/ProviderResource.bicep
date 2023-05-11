@description('description')
param userAssignedIdentityName string

@description('description')
param mapsAccountName string

@description('description')
param guid string

var Azure_Maps_Data_Reader = 'Azure Maps Data Reader'

resource mapsAccountName_Microsoft_Authorization_guid 'Microsoft.Maps/accounts/providers/roleAssignments@2018-09-01-preview' = {
  name: '${mapsAccountName}/Microsoft.Authorization/${guid}'
  properties: {
    roleDefinitionId: Azure_Maps_Data_Reader
    principalId: reference(userAssignedIdentityName).principalId
    principalType: 'ServicePrincipal'
  }
}
