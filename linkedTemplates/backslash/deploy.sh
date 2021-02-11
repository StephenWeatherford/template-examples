#!/bin/sh

STGACCT=sawdeploy
STGCONTAINER=sawdeploy
TEMPLATE=bs.json
PARAMS=bs.params.json
RG=deleteme

az storage blob sync -c $STGCONTAINER --account-name $STGACCT -s ./templates

BASEURI=https://sawdeploy.blob.core.windows.net/${STGCONTAINER}
SAS='sv=2019-12-12&si=sawdeploy&sr=c&sig=SzLJFWrlZqbeKTCb4UXtPWuO64yu9Fv2McMjpX%2FqG9A%3D'
URI=${BASEURI}/${TEMPLATE}

echo Deploying: $URI
set -x
az deployment group create -g ${RG} -u ${URI} -q ${SAS} -p ${PARAMS}
