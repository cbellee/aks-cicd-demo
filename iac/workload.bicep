param environment string
param clusterName string
param gitRepoUrl string

resource existingCluster 'Microsoft.ContainerService/managedClusters@2022-10-02-preview' existing = {
  name: clusterName
}

module fluxExtension './modules/flux-extension.bicep' = {
  name: 'module-flux'
  params: {
    aksClusterName: existingCluster.name
    gitRepoUrl: gitRepoUrl
    environmentName: environment
  }
}
