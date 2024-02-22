# cd to ~/repos before calling

[cmdletbinding()]
param ()

bicep/scripts/PublishExamplesToRegistry.ps1 -BicepPath ./bicep/src/Bicep.Cli/bin/Debug/net8.0 -ExamplesPath ./bicep-registry-modules/avm/res -RegistryName sawbiceppublic -Tag v1.0.1 -RegistryPathPrefix "sourcetest/avm" -Verbose -Debug
bicep/scripts/PublishExamplesToRegistry.ps1 -BicepPath ./bicep/src/Bicep.Cli/bin/Debug/net8.0 -ExamplesPath ./bicep-registry-modules/modules -RegistryName sawbiceppublic -Tag v1.0.1 -RegistryPathPrefix "sourcetest/br" -Verbose -Debug
