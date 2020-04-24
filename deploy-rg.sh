# Deploy to resource group
if $2; then
    az group deployment create -g deleteme --handle-extended-json-format --template-file $1
else
    az group deployment create -g deleteme --handle-extended-json-format --template-file $1 --parameters $2
fi