metadata description = 'description'

/*
   src\Bicep.Cli\bin\Debug\net8.0\bicep publish ..\template-examples\bicep\modules\simpleModule\main.bicep --target br:sawbicep.azurecr.io/simple/module:255 --with-source

   src\Bicep.Cli\bin\Debug\net8.0\bicep publish ..\template-examples\bicep\modules\simpleModule\main.bicep --target br:sawbicep.azurecr.io/123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_1hundreds_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_2hundreds_123456789_123456789_123456789_12345678/module:255

br:sawbicep.azurecr.io/123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_1hundreds_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_2hundreds_123456789_123456789_123456789_12345678/module:255
*/


@minLength(3)
@maxLength(11)
@sys.description('hello')
param namePrefix string = 'hello'
param location string = resourceGroup().location

module stgModule './storageAccount.bicep' = {
  name: 'storageDeploy'
  params: {
    storagePrefix: namePrefix
    location: location
  }
}

output storageEndpoint object = stgModule.outputs.storageEndpoint
