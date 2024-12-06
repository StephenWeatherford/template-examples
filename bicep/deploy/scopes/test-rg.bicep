targetScope = 'resourceGroup'

module modKeyvault1 'br/public:avm/res/key-vault/vault:0.9.0' = {
  name: 'keyvault1'
  params: {
    name: uniqueString(resourceGroup().id, 'keyvault demo2')
  }
}
