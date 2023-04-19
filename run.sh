#!/usr/bin/env bash

set -x -euo pipefail

: "${AZURE_LOCATION:="westeurope"}"
: "${AZURE_RESOURCE_GROUP:="rg-tmp-${PROJECT_KEY}"}"
: "${DATABRICKS_WORKSPACE_NAME="dbws-${PROJECT_KEY}"}"

# Delete the resource group if it exists
if "$(az group exists --name "${AZURE_RESOURCE_GROUP}")"
then
    az group delete --name "${AZURE_RESOURCE_GROUP}" --yes
fi

# Create the resource group
az group create --location "${AZURE_LOCATION}" --name "${AZURE_RESOURCE_GROUP}"

BICEP_PARAMETERS=( "--parameters" "workspaceName=${DATABRICKS_WORKSPACE_NAME}" )

az bicep version

# Deploy with 10 minute timeout
time timeout 10m az deployment group create --template-file main.bicep "${BICEP_PARAMETERS[@]}" --resource-group "${AZURE_RESOURCE_GROUP}" --name "${AZURE_RESOURCE_GROUP}" --mode "${BICEP_MODE}" --verbose || :

# Get the activity log
az monitor activity-log list --resource-group "${AZURE_RESOURCE_GROUP}" --output json \
    | tee activity-log-mode-"${BICEP_MODE}".json \
    | jq -r '.[] | [ .eventTimestamp, .operationName.localizedValue, .status.localizedValue ] | @tsv' | sort
