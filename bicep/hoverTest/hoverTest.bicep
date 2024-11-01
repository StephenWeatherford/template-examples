@description('This is localModule')
module localModule 'modules/module1.bicep' = {
  name: 'localModule'
}

@description('This is localTemplate')
module localTemplate 'modules/template1.json' = {
  name: 'localTemplate'
}

@description('This is localTemplateSpec')
module privateOci 'br:sawbicep.azurecr.io/misc/deep-stuff/and-deeper/and-deeper/just-right/modules/storage:v3' = {
  name: 'privateOci'
  params: {}
}

@description('This is localTemplateSpec')
module templateSpec 'ts:e5ef2b13-6478-4887-ad57-1aa6b9475040/sawbicep/storageSpec:2.0a' = {
  name: 'templateSpec'
  params: {
    loc: 'westus3'
  }
}

@description('This is publicOci')
module publicOci 'br/public:app/app-configuration:1.0.1' = {
  name: 'publicOci'
  params: {}
}

module a 'br:sawbiceppublic.azurecr.io/demo/'

/*
Exception has occurred: CLR/System.Text.Json.JsonReaderException
Exception thrown: 'System.Text.Json.JsonReaderException' in System.Private.CoreLib.dll: ''<' is an invalid start of a value. LineNumber: 0 | BytePositionInLine: 0.'
   at System.Text.Json.ThrowHelper.ThrowJsonReaderException(Utf8JsonReader& json, ExceptionResource resource, Byte nextByte, ReadOnlySpan`1 bytes)
   at System.Text.Json.Utf8JsonReader.ConsumeValue(Byte marker)
   at System.Text.Json.Utf8JsonReader.ReadFirstToken(Byte first)
   at System.Text.Json.Utf8JsonReader.ReadSingleSegment()
   at System.Text.Json.Utf8JsonReader.Read()
   at System.Text.Json.JsonDocument.Parse(ReadOnlySpan`1 utf8JsonSpan, JsonReaderOptions readerOptions, MetadataDb& database, StackRowStack& stack)
   at System.Text.Json.JsonDocument.Parse(ReadOnlyMemory`1 utf8Json, JsonReaderOptions readerOptions, Byte[] extraRentedArrayPoolBytes, PooledByteBufferWriter extraPooledByteBufferWriter)
   at System.Text.Json.JsonDocument.<ParseAsyncCore>d__65.MoveNext()
   at Azure.Containers.ContainerRegistry.ContainerRegistryRestClient.<GetRepositoriesAsync>d__20.MoveNext()
   at Azure.Containers.ContainerRegistry.ContainerRegistryClient.<>c__DisplayClass17_0.<<GetRepositoryNamesAsync>g__FirstPageFunc|0>d.MoveNext()
   at Azure.Core.PageableHelpers.FuncAsyncPageable`1.<AsPages>d__4.MoveNext()
   at Azure.Core.PageableHelpers.FuncAsyncPageable`1.<AsPages>d__4.System.Threading.Tasks.Sources.IValueTaskSource<System.Boolean>.GetResult(Int16 token)
   at Azure.AsyncPageable`1.<GetAsyncEnumerator>d__6.MoveNext()
   at Azure.AsyncPageable`1.<GetAsyncEnumerator>d__6.MoveNext()
   at Azure.AsyncPageable`1.<GetAsyncEnumerator>d__6.System.Threading.Tasks.Sources.IValueTaskSource<System.Boolean>.GetResult(Int16 token)
   at Bicep.Core.Registry.AzureContainerRegistryManager.<GetCatalogAsync>d__11.MoveNext() in C:\Users\stephwe\repos\bicep\src\Bicep.Core\Registry\AzureContainerRegistryManager.cs:line 209


   Exception has occurred: CLR/System.Text.Json.JsonReaderException
Exception thrown: 'System.Text.Json.JsonReaderException' in System.Private.CoreLib.dll: ''<' is an invalid start of a value. LineNumber: 0 | BytePositionInLine: 0.'
   at System.Text.Json.ThrowHelper.ThrowJsonReaderException(Utf8JsonReader& json, ExceptionResource resource, Byte nextByte, ReadOnlySpan`1 bytes)
   at System.Text.Json.Utf8JsonReader.ConsumeValue(Byte marker)
   at System.Text.Json.Utf8JsonReader.ReadFirstToken(Byte first)
   at System.Text.Json.Utf8JsonReader.ReadSingleSegment()
   at System.Text.Json.Utf8JsonReader.Read()
   at System.Text.Json.JsonDocument.Parse(ReadOnlySpan`1 utf8JsonSpan, JsonReaderOptions readerOptions, MetadataDb& database, StackRowStack& stack)
   at System.Text.Json.JsonDocument.Parse(ReadOnlyMemory`1 utf8Json, JsonReaderOptions readerOptions, Byte[] extraRentedArrayPoolBytes, PooledByteBufferWriter extraPooledByteBufferWriter)
   at System.Text.Json.JsonDocument.<ParseAsyncCore>d__65.MoveNext()
   at Azure.Containers.ContainerRegistry.ContainerRegistryRestClient.<GetRepositoriesAsync>d__20.MoveNext()
   at Azure.Containers.ContainerRegistry.ContainerRegistryClient.<>c__DisplayClass17_0.<<GetRepositoryNamesAsync>g__FirstPageFunc|0>d.MoveNext()
   at Azure.Core.PageableHelpers.FuncAsyncPageable`1.<AsPages>d__4.MoveNext()
   at Azure.Core.PageableHelpers.FuncAsyncPageable`1.<AsPages>d__4.System.Threading.Tasks.Sources.IValueTaskSource<System.Boolean>.GetResult(Int16 token)
   at Azure.AsyncPageable`1.<GetAsyncEnumerator>d__6.MoveNext()
   at Azure.AsyncPageable`1.<GetAsyncEnumerator>d__6.MoveNext()
   at Azure.AsyncPageable`1.<GetAsyncEnumerator>d__6.System.Threading.Tasks.Sources.IValueTaskSource<System.Boolean>.GetResult(Int16 token)
   at Bicep.Core.Registry.AzureContainerRegistryManager.<GetCatalogAsync>d__11.MoveNext() in C:\Users\stephwe\repos\bicep\src\Bicep.Core\Registry\AzureContainerRegistryManager.cs:line 209

   */
