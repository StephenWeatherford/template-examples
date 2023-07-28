/*

~/repos/bicep/src/Bicep.Cli/bin/Debug/net7.0/bicep publish ~/repos/template-examples/bicep/modules/complicated/my\ entrypoint.bicep --target br:sawbicep.azurecr.io/complicated:v1

 */

metadata description = '''Azure Storage is a cloud-based storage service offered by Microsoft that provides highly scalable and durable storage for data and applications. Storage Accounts are the fundamental storage entity in Azure Storage and can be used to store data objects such as blobs, files, queues, tables, and disks.

This Bicep module allows users to create or use existing Storage Accounts with options to control redundancy, access, and security settings. Zone-redundancy allows data to be stored across multiple Availability Zones, increasing availability and durability. Virtual network rules can be used to restrict or allow network traffic to and from the Storage Account. Encryption and TLS settings can be configured to ensure data security.

The module supports both blob and file services, allowing users to store and retrieve unstructured data and files. The output of the module is the ID of the created or existing Storage Account, which can be used in other Azure resource deployments.'''

module m1 'br/public:samples/hello-world:1.0.2' = {
  name: 'm1'
  params: {
    name: 'me myself'
  }
}

output greeting string = m1.outputs.greeting
