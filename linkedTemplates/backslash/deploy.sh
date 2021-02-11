#!/bin/sh

STGACCT=sawdeploy
STGCONTAINER=sawdeploy
az storage blob sync -c $STGCONTAINER --account-name $STGACCT -s .

BASEURI=https://sawdeploy.blob.core.windows.net/sawdeploy
SAS="?sv=2019-12-12&si=sawdeploy&sr=c&sig=SzLJFWrlZqbeKTCb4UXtPWuO64yu9Fv2McMjpX%2FqG9A%3D"
URI=${BASEURI}/bs.json${SAS}

echo Deploying: $URI
set -x
az deployment group create -g deleteme -u $URI
