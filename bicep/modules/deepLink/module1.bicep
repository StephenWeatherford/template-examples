/*
~/repos/bicep/src/Bicep.Cli/bin/Debug/net8.0/bicep publish ~/repos/template-examples/bicep/modules/deepLink/module1.bicep --target br:sawbicep.azurecr.io/demo/module1:v1
*/

module cogsvc 'br/public:ai/cognitiveservices:1.0.3' = {
  name: 'cogsvc'
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: 'name'
  location: 'westus'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: '1.19.7'
    dnsPrefix: 'dnsprefix'
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: 'adminUserName'
      ssh: {
        publicKeys: [
          {
            keyData: 'REQUIRED'
          }
        ]
      }
    }
  }
}
