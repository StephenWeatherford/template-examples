module creatingVM 'nestedtemplates/createVM.bicep' = {
  name: 'creatingVM'
  params: {
    _artifactsLocation: 'my artifactsLocation'
    '_artifactsLocationSasToken': 'my artifactsLocationSasToken'
    adminPasswordOrKey: 'adminPasswordOrKey'
    adminUsername: 'adminUsername'
  }
}
