# Deploy to resource group
if [ -z "$2" ]; then
    az deployment group create -g deleteme --template-file $1
else
    az deployment group create -g deleteme --template-file $1 --parameters $2
fi