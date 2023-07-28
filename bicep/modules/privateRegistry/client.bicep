// module m 'br/saw:misc/deep-stuff/and-deeper/and-deeper/just-right/modules/storage:v1' = {
//   name: 'm'
//   params: {
//     location: 'westus'
//     storagePrefix: 'saw'
//   }
// }

// module m2 'br/saw:misc/deep-stuff/and-deeper/and-deeper/just-right/modules/storage:v2' = {
//   name: 'm2'
//   params: {}
// }

// module m3 'br/saw:misc/deep-stuff/and-deeper/and-deeper/just-right/modules/storage:v3' = {
//   name: 'm3'
//   params: {}
// }

//'br/public:samples/hello-world:'
'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AA1bzoYk.img?w=768&h=480&m=6&x=590&y=366&s=105&d=105'

module mLatest2 'br/public:app/app-configuration:1.0.1' = {
}

module mLatest 'br/public:' = {
  name: 'mLatest'
  params: {
    name1: 'value1'
    name2: 'value2'
    name3: 'value3'
    name4: 'value4'
    name5: 'value5'
    name6: 'value6'
  }
}

module m5 'helloWorld/main.bicep' = {
  name: 'm5'
  params: {
    location: 'westus'
  }
}


module m6 'br/public:app/app-configuration:1.0.1' = {
  name: 'm6'
}


module m7 'br/public:app/dapr-containerapps-environment:1.2.2' = {
  name: 'm7'
  params: {
    daprComponentType: 
    location: 
    nameseed: 
  }
}
