targetScope = 'tenant'

param policyAssignmentName string = 'myPolicyAssignment'

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' existing = {
  name: policyAssignmentName
}

output policyAssignmentId string = policyAssignment.id
