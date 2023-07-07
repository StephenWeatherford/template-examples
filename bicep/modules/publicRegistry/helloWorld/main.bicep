/*

Show login server name: 
az acr show --resource-group sawbicep --name sawbicep --query loginServer
> "sawbicep.azurecr.io"

List registries:
az acr repository list --name sawbicep --output table
> misc/deep-stuff/and-deeper/and-deeper/just-right/modules/storage

~/repos/bicep/src/Bicep.Cli/bin/Debug/net7.0/bicep publish main.bicep --target br:sawbicep.azurecr.io/misc/deep-stuff/and-deeper/and-deeper/just-right/modules/storage:v3 --documentationUri https://www.contoso.com/exampleregistry.html

Tags:
az acr repository show-tags --name sawbicep --repository misc/deep-stuff/and-deeper/and-deeper/just-right/modules/storage --output table

*/

metadata name = 'Description Demonstration'
metadata description = 'This module is designed to demonstrate a module\'s short description which would tell what the module is for.'
metadata owner = 'bicepadmin'

module m1 'br/public:samples/hello-world:1.0.2' = {
  name: 'm1'
  params: {
    name: 'me myself'
  }
}

output greeting string = m1.outputs.greeting
