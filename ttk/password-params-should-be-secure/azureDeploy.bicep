param pass_adminUsername string
param fail_adminPasswordInt int

param fail_adminPassword string
param fail_ADMINpassword2 string
param fail_adminPasswords string
param fail_adminPasswordObject object
param fail_myAccountKey string

// Exceptions allowed for certain known ARM patterns:

// secret + Permissions (secret permissions is an accessPolicy property for keyvault)
param pass_secretpermissions string
param fail_secretmissions string

// secret + Version (URL or simply the version property of a secret)
param pass_secretVersion string
param fail_secretVerse string

// secret + url/uri
param pass_secretUri string
param pass_secretUrl string = 'default'
param fail_secretUrtext string = 'default'

// secret + name (keyvault secret's name)
param pass_secretname string
param pass_keyVaultSecretName object
param fail_secretNombre string
