// public module (no source)
module modCognitiveServices 'br/public:ai/cognitiveservices:1.1.1' = {
  name: 'modCognitiveServices'
}

// public avm module (no source)
module modSshPublicKey 'br/public:avm/res/compute/ssh-public-key:0.2.2' = {
  name: 'modSshPublicKey'
  params: {
    name: 'sshPublicKey'
  }
}
// private module (no source)
module modComplicatedv1 'br/saw:demo/complicated:v1' = {
  name: 'modComplicatedv1'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
  dependsOn: [
  ]
}

// private module (published with source)
module modComplicatedv2 'br/saw:demo/complicated:v2' = {
  name: 'modComplicatedv2'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
  dependsOn: [
  ]
}
