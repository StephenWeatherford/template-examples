/*

Show login server name: 
az acr show --resource-group sawbicep --name  sawbicep --query loginServer
> "sawbicep.azurecr.io"

List registries:
az acr repository list --name sawbicep --output table
> misc/deep-stuff/and-deeper/and-deeper/just-right/modules/storage

~/repos/bicep/src/Bicep.Cli/bin/Debug/net7.0/bicep publish main.bicep --target br:sawbicep.azurecr.io/misc/deep-stuff/and-deeper/and-deeper/just-right/modules/storage:v3 --documentationUri https://www.contoso.com/exampleregistry.html
*/

metadata description = 'This is a description for publicRegistry/helloWorld'

module m1 'br/public:samples/hello-world:1.0.2' = {
  name: 'm1'
  params: {
    name: 'me myself'
  }
}

output greeting string = m1.outputs.greeting
