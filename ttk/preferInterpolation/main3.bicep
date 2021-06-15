// module validModule './module.bicep' = {
//   name: 'storageDeploy'
//   params: {
//     name: 'contoso'
//   }
// }

// resource runtimeValidRes4 'Microsoft.Advisor/recommendations/suppressions@2020-01-01' = {
//   name: concat(validModule['name'], 'v1')
// }
var s = 'management.core.windows.net'
