resource db 'Microsoft.DBforMySQL/servers@2017-12-01-preview' = {
  name: 'db]'
#disable-next-line no-hardcoded-location
  location: 'westeurope'
  properties: {
    administratorLogin: 'sa'
    administratorLoginPassword: 'don\'t put passwords in plain text'
    createMode: 'Default'
    sslEnforcement: 'Disabled'
  }
}
