module m1 'br:sawbicep.azurecr.io/demo/complicated:v24' = {
  name: 'complicated'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
}

module m2 'br/public:ai/bing-resource:1.0.2' = {
   name: 'm2'
}
