# Deploy to subscription
az deployment create --location WestUS --handle-extended-json-format --template-file $1 --parameters $2
