---
platforms: linux 
author: brentmcconnell
---

Packer scripts for building images in Azure 

## Running these Samples ##

To run this sample:

Ensure you have an active Azure subscription and that the `az` CLI has been installed and authenticated.

To run the scripts as is you will also need a Resource Group named `Images` where the custom images will be placed.

NOTE:  These scripts require environment variables to execute properly.  The following are required:

    - AZURE_CLIENTID
    - AZURE_SECRET
    - AZURE_SUBSCRIPTIONID
    - AZURE_TENANTID
    - AZURE_CLOUD
    - AZURE_LOCATION

If you are running Azure Commerical use:
`export AZURE_CLOUD=Public`

If you are in Azure Government:
`export AZURE_CLOUD=USGovernment`

To get the locations you can use execute:
`az account list-locations`

## Helper Script ##
For those of us too lazy to actually set these variables manually there is a helper script in the `scripts` directory of this repo.  This script requires 'jq' and 'zsh'.  Using this script you can create an Azure authentication file and use it to set the variables above.  It will determine the current Cloud you are logged into with `az` and also default to a specific region.

To create an Azure Auth file:
`az ad sp create-for-rbac --sdk-auth > my.azureauth`

Once this file is created you can set these variables using the script:
`source ./az-set-azure-environment ./my.azureauth`

>Make sure you use `source` to execute the script.  This will ensure the environment variables are maintained in your current shell.

Once the environment is setup correctly you can run the packer scripts normally:
`packer build ubuntu.json`

## More information ##

[http://azure.com/](http://azure.com/)

If you don't have a Microsoft Azure subscription you can get a FREE trial account [here](http://go.microsoft.com/fwlink/?LinkId=330212)

---

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.