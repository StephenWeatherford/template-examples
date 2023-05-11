@description('The name for the Slack connection.')
param slackConnectionName string = 'SlackConnection'

@description('Location for all resources.')
param location string

resource slackConnectionName_resource 'Microsoft.Web/connections@2016-06-01' = {
  location: location
  name: slackConnectionName
  properties: {
    api: {
      id: subscriptionResourceId('Microsoft.Web/locations/managedApis', location, 'slack')
    }
    displayName: 'slack'
  }
}