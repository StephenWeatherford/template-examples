@description('This is localModule')
module localModule 'modules/module1.bicep' = {
  name: 'localModule'
}

@description('This is localTemplate')
module localTemplate 'modules/template1.json' = {
  name: 'localTemplate'
}

@description('This is localTemplateSpec')
module privateOci 'br:sawbicep.azurecr.io/misc/deep-stuff/and-deeper/and-deeper/just-right/modules/storage:v3' = {
  name: 'privateOci'
  params: {}
}

@description('This is localTemplateSpec')
module templateSpec 'ts:e5ef2b13-6478-4887-ad57-1aa6b9475040/sawbicep/storageSpec:2.0a' = {
  name: 'templateSpec'
  params: {
    loc: 'westus3'
  }
}

@description('This is publicOci')
module publicOci 'br/public:app/app-configuration:1.0.1' = {
  name: 'publicOci'
  params: {}
}
