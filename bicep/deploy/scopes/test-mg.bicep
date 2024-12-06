targetScope = 'managementGroup'

param policyAssignmentName string = 'myPolicyAssignment'
param displayName string = 'My Policy Assignment'
param policyDefinitionId string = '/providers/Microsoft.Authorization/policDefinitions/abcd1234'

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: policyAssignmentName
  properties: {
    displayName: displayName
    policyDefinitionId: policyDefinitionId
  }
}
