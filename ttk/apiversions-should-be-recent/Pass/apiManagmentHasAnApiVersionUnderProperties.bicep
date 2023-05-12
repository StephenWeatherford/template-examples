resource foo_bar 'Microsoft.ApiManagement/service/apis@2021-01-01-preview' = {
  name: 'foo/bar'
  properties: {
    displayName: 'test'
    apiRevision: '1'
    description: 'Init'
    subscriptionRequired: true
    path: 'foo'
    protocols: [
      'https'
    ]
    isCurrent: true
    apiVersion: 'v1'
    apiVersionSetId: resourceId('Microsoft.ApiManagement/service/apiVersionSets', 'foo', 'bar')
  }
}