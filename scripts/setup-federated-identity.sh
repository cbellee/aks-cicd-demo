TENANT_ID=$(az account show --query tenantId -o tsv)
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
APP_NAME='aks-cicd-demo-github-federated-id'
CREDENTIAL_NAME="$APP_NAME-cred"
GITHUB_USER='cbellee'
GITHUB_REPO='aks-cicd-demo'
GITHUB_BRANCH=main

# create application registration & return its ObjectId
APP_OBJECT_ID=$( az ad app list --display-name github-action-federated-id --query [].id -o tsv)
if [ $APP_OBJECT_ID = "" ] 
then
  APP_OBJECT_ID=$(az ad app create --display-name $APP_NAME --query id -o tsv)
fi

# get the app registration's ClientId
APP_CLIENT_ID=$(az ad app show --id $APP_OBJECT_ID --query appId -o tsv)
if [ $APP_CLIENT_ID = "" ]
then
  APP_CLIENT_ID=$(az ad app show --id $APP_OBJECT_ID --query appId -o tsv)
fi

# create a service principal using the app registration'sn ClientId
SP_OBJECT_ID=$(az ad sp show --id $APP_CLIENT_ID --query id -o tsv)
if [ $SP_OBJECT_ID = "" ]
then
  SP_OBJECT_ID=$(az ad sp create --id $APP_CLIENT_ID --query id -o tsv)
fi

# assign role to the service principal at the subscription scope
az role assignment create --role owner \
  --subscription $SUBSCRIPTION_ID \
  --assignee-object-id  $SP_OBJECT_ID \
  --assignee-principal-type ServicePrincipal \
  --scope /subscriptions/$SUBSCRIPTION_ID

# add federated credentials to app registration
az rest --method POST --uri "https://graph.microsoft.com/beta/applications/$APP_OBJECT_ID/federatedIdentityCredentials" --body "{\"name\":\"$CREDENTIAL_NAME\",\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"repo:$GITHUB_USER/$GITHUB_REPO:ref:refs/heads/$GITHUB_BRANCH\",\"description\":\"GitHub Federated Identity Credential\",\"audiences\":[\"api://AzureADTokenExchange\"]}" 

# add the following 3 secrets to your repository in the GitHub portal
# in 'Settings' -> 'Secrets' -> 'Actions' -> 'New repository secret'
echo "AZURE_CLIENT_ID: $APP_CLIENT_ID" 
echo "AZURE_TENANT_ID: $TENANT_ID" 
echo "AZURE_SUBSCRIPTION_ID: $SUBSCRIPTION_ID" 

