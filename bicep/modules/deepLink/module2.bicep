/*
~/repos/bicep/src/Bicep.Cli/bin/Debug/net8.0/bicep publish ~/repos/template-examples/bicep/modules/deepLink/module2.bicep --target br:sawbicep.azurecr.io/demo/module2:v1
*/

module module1 'br/saw:module1:v1' = {
  name: 'm1'
}
