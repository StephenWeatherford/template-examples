# Deploy to resource group
az group deployment create -g deleteme --handle-extended-json-format --template-file $1 --parameters $2
