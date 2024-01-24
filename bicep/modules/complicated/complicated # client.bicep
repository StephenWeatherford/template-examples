module m1 'br/saw:complicated:v1' = {
  name: 'complicated'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
}

module m2 'br/public:ai/bing-resource:1.0.2' = {
   name: 'm2'
}
