#!/bin/sh
VERSION=${1-master}
URI=https://raw.githubusercontent.com/StephenWeatherford/template-examples/${VERSION}/linkedTemplates/contentVersion/main.json

echo Deploying: $URI
set -x
az deployment group create -g deleteme -u $URI
