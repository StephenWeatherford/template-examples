az group create --name deleteme --location westus
az group deployment create -g deleteme --template-file $1
