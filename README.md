## Azure Kubernetes Service CI/CD Demo

### Overview
This repo demonstrates how to deploy networking infrastructure, Azure Kubernetes Service (AKS) clusters and the Azure voting app across 3 environments, dev, test & prod.

Two GitHub action workflows deploy the solution:

- Infrastructure (Networking, Monitoring, AKS clusters, etc.)
  - .github/workflows/infrastructure.yml
- Workload (Azure Voting app)
  - .github/workflows/wd.yml

### Pre-requisites

- Bash shell
- kubectl CLI
- Github account
  - Clone fork this repo to your github account, then clone it locally
  - Create a Federated credential between your GitHub account & Azure subscription
    - The script `./iac/setup-federated-identity.sh` demonstrates how configure this
    - Alternatively, instructions can be found [here](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-portal%2Clinux#use-the-azure-login-action-with-openid-connect)

### Deployment

- Run the Infrastructure workflow
  - Either:
    - Make a change to the repo, commit & push the changes (`git add .`, `git commit`, `git push`)
  - Or:
    - Run the workflow from the GitHub Actions tab in the GitHub portal.

### Testing

- Only the production environment is exposed via an Azure Load Balancer
  - Get the production cluster's kubeconfig file
    - `$ az aks get-credentials -n '<your cluster name>' -g 'demo-workload-prod-rg' --admin`
  - Using the bash shell, get the public IP assigned to the 'azure-vote-front' service in the 'azure-vote' namespace 
    - `$ EXTERNAL_IP=$(kubectl get svc azure-vote-front -n azure-vote --output jsonpath='{.status.loadBalancer.ingress[0].ip}')`
  - Hit the endpoint using curl (or type 'http://<EXTERNAL_IP>' in a browser
    - `$ curl http://$EXTERNAL_IP`
