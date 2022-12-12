param environment string
param clusterName string
param gitRepoUrl string
param resourceGroupName string

targetScope = 'subscription'

resource existingCluster 'Microsoft.ContainerService/managedClusters@2022-08-03-preview' existing = {
  name: clusterName
  scope: resourceGroup(resourceGroupName)
}

module fluxExtension './modules/flux-extension.bicep' = {
  name: 'module-flux'
  scope: resourceGroup(resourceGroupName)
  params: {
    aksClusterName: existingCluster.name
    gitRepoUrl: gitRepoUrl
    environmentName: environment
  }
}

output clusterName string = existingCluster.name
