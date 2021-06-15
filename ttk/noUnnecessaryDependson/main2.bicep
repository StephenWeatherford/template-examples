resource dnsZone 'Microsoft.Network/dnszones@2018-05-01' = {
  name: 'myZone'
  location: 'global'
}

resource otherResource 'Microsoft.Example/examples@2020-06-01' = {
  name: 'exampleResource'
  dependsOn: [
    dnsZone // Redundant needed because of the reference to dnsZone in properties.nameServers
  ]
  properties: {
    // get read-only DNS zone property
    nameServers: dnsZone.properties.nameServers
  }
}

resource otherResource2 'Microsoft.Example/examples@2020-06-01' = {
  name: 'exampleResource2'
  dependsOn: [
    dnsZone // Needed because there is no reference to dnsZone otherwise
  ]
}

resource otherResource3 'Microsoft.Example/examples@2020-06-01' = {
  name: 'exampleResource3'
  dependsOn: [
    dnsZone // Needed because there is no reference to dnsZone otherwise
  ]
}

resource otherResource4 'Microsoft.Example/examples@2020-06-01' = {
  name: 'exampleResource4'
  dependsOn: [
    dnsZone // Needed because there is no reference to dnsZone otherwise
  ]
}

resource otherResource5 'Microsoft.Example/examples@2020-06-01' = {
  name: 'exampleResource5'
  dependsOn: [
    dnsZone // Needed because there is no reference to dnsZone otherwise
  ]
}

resource otherResource6 'Microsoft.Example/examples@2020-06-01' = {
  name: 'exampleResource6'
  dependsOn: [
    otherResource // Needed because there is no reference to dnsZone otherwise
    otherResource3
    otherResource5
  ]
}
 




// array of storage account names
param storageAccounts array

resource storageAccountResources 'Microsoft.Storage/storageAccounts@2019-06-01' = [for storageName in storageAccounts: {
  name: storageName
  location: resourceGroup().location
  properties: {
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
    }
  }
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}]
