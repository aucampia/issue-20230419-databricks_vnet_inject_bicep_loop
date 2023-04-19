# Deploying an Azure Databricks workspace with VNet injection using Bicep with complete mode loops indefinitely

When deploying an Azure Databricks workspace with VNet injection using Bicep with complete mode, the deployment loops indefinitely (at least longer than an hour). It seems the problem is that it keeps trying to run "Delete Network Intent Policy" according to the resource group's activity log, of which an extract can be seen below:

```
2023-04-19T21:05:52.441707+00:00	Delete Network Intent Policy	Failed
2023-04-19T21:05:52.926106+00:00	Delete Network Intent Policy	Failed
2023-04-19T21:07:22.651993+00:00	Delete Network Intent Policy	Started
2023-04-19T21:07:23.402003+00:00	Delete Network Intent Policy	Failed
2023-04-19T21:07:23.781610+00:00	Delete Network Intent Policy	Started
2023-04-19T21:07:24.187993+00:00	Delete Network Intent Policy	Failed
```

This repo contains a script `./run.sh` to run the deployment, and it can run in incremental mode or complete mode.

The script can be run with:

```bash
# Run without incremental mode
PROJECT_KEY=zmmbsj-bmi BICEP_MODE=Incremental ./run.sh 2>&1 | tee run-mode-Incremental.log
# Run with complete mode
PROJECT_KEY=zmmbsj-bmc BICEP_MODE=Complete ./run.sh 2>&1 | tee run-mode-Complete.log
```

The Bicep template used comes from the `databricks-all-in-one-template-for-vnet-injection` quickstart [[ref](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.databricks/databricks-all-in-one-template-for-vnet-injection/main.bicep)].

The output of the script can be found in the repo in the following files:

- [`run-mode-Incremental.log`](./run-mode-Incremental.log)
- [`run-mode-Complete.log`](./run-mode-Complete.log)

The resource group activity log can be found in the following files:

- [`activity-log-mode-Incremental.json`](./activity-log-mode-Incremental.json)
- [`activity-log-mode-Complete.json`](./activity-log-mode-Complete.json)

