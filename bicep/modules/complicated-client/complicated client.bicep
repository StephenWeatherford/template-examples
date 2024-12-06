
module m 'br:sawbicep.azurecr.io/demo/complicated:v103' = {
  name: 'm'
  params: {
    location: 'westus'
    storagePrefix: 'stephwe'
  }
}

// public module (no source)
module modCognitiveServices 'br/public:ai/cognitiveservices:1.1.1' = {
  name: 'modCognitiveServices'
}

// public avm module (source available)
module modSshPublicKey 'br/public:avm/res/compute/ssh-public-key:0.2.4' = {
  name: 'modSshPublicKey'
  params: {
    name: 'sshPublicKey'
  }
}

// aliased private module (no source)
module modComplicatedv1 'br/demo:complicated:v1' = {
  name: 'modComplicatedv1'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
  dependsOn: [
  ]
}

// aliased private module (has source)
module modComplicatedv2 'br/demo:complicated:v2' = {
  name: 'modComplicatedv2'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
  dependsOn: [
  ]
}

// fully-qualified private module (no source)
module modFQComplicatedv1 'br:sawbicep.azurecr.io/demo/complicated:v1' = {
  name: 'modFQComplicatedv1'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
  dependsOn: [
  ]
}

// fully-qualified private module (has source)
module modFQComplicatedv2 'br:sawbicep.azurecr.io/demo/complicated:v2' = {
  name: 'modFQComplicatedv2'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
  dependsOn: [
  ]
}

// v0.23
// private module (no source)
module modComplicatedv23v1 'br/demo:complicated:v23-v1' = {
  name: 'modComplicatedv23-v1'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
  dependsOn: [
  ]
}

// private module (has source)
module modComplicatedv23v2 'br/demo:complicated:v23-v2' = {
  name: 'modComplicatedv23-v2'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
  dependsOn: [
  ]
}

// metadata version 1

module modComplicatedmv1 'br/demo:complicated:metadatav1' = {
  name: 'modComplicatedmv1'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
  dependsOn: [
  ]
}

module modComplicatedmv2 'br/demo:complicated:metadatav1-nofiles' = {
  name: 'modComplicatedmv2'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
  dependsOn: [
  ]
}

// Metadata versions

module modComplicated_metadata_neg1 'br/demo:complicated:v2-metadata-1' = {
  name: 'v2-metadata-neg1'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
  dependsOn: [
  ]
}

module modComplicated_metadata_0 'br/demo:complicated:v2-metadata0' = {
  name: 'v2-metadata-0'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
  dependsOn: [
  ]
}

module modComplicated_metadata_1 'br/demo:complicated:v2-metadata1' = {
  name: 'v2-metadata-1'
  params: {
    location: 'westus3'
    storagePrefix: 'stephwe'
  }
  dependsOn: [
  ]
}
