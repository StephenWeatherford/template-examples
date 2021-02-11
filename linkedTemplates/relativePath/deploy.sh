#!/bin/sh

STGACCT=sawdeploy
STGCONTAINER=relativepath-2020-06-01
TEMPLATE=main.json
RG=deleteme
az storage blob sync -c $STGCONTAINER --account-name $STGACCT -s ./templates

BASEURI=https://sawdeploy.blob.core.windows.net/${STGCONTAINER}
SAS='sv=2019-12-12&si=relativepath&sr=c&sig=5D2MMGQj8wwij4fwnGJ%2BjkrcJc%2B6nr4gAkwCUdOjpqE%3D'
URI=${BASEURI}/${TEMPLATE}

echo Deploying: $URI
set -x
az deployment group create -g ${RG} -u ${URI} -q ${SAS} -p templates/main.parameters.json
