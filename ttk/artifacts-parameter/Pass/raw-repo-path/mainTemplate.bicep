@secure()
param _artifactsLocation string = deployment().properties.templateLink.uri

@secure()
param _artifactsLocationSasToken string = ''
