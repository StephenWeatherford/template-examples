sed -i '' 's/serverFarms@[0-9][0-9a-z-]*/serverFarms@2020-12-01/ig' $1
sed -i '' 's/sites@[0-9][0-9a-z-]*/sites@2020-12-01/ig' $1
sed -i '' 's/namespaces@[0-9][0-9a-z-]*/namespaces@2017-04-01/ig' $1
