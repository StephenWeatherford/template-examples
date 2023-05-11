resource nested 'Microsoft.Resources/deployments@2021-04-01' = {
  'name': 'nested'
  'properties': {
    'mode': 'Complete'
    'expressionEvaluationOptions': {
      'scope': 'outer'
    }
  }
}

resource nested2 'Microsoft.Resources/deployments@2021-04-01' = {
  name: 'nested2'
  properties: {
    mode: 'Complete'
    template: {
      type: 'Microsoft.Resources/deployments'
      apiVersion: '2021-04-01'
      name: 'nestedTemplate'
      properties: {
        expressionEvaluationOptions: {
          scope: 'outer'
        }
      }
    }
  }
}
