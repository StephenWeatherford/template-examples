# blocked by https://github.com/Azure/azure-cli/issues/13998: az deployment create --location WestUS --template-file ./master1.json --handle-extended-json-format --parameters @master1.dev.params.json
#az group deployment create -g deleteme --template-file ./twoLinked-master.json --handle-extended-json-format --parameters @twoLinked-master.dev.params.json
az deployment group create -g deleteme --template-file ./twoLinked-master.json --handle-extended-json-format
