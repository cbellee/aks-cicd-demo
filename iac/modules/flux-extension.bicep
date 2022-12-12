param aksClusterName string
param gitRepoUrl string

@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string

resource aks 'Microsoft.ContainerService/managedClusters@2022-10-02-preview' existing = {
  name: aksClusterName
}

resource fluxExtension 'Microsoft.KubernetesConfiguration/extensions@2022-11-01' = {
  name: 'flux'
  scope: aks
  properties: {
    extensionType: 'microsoft.flux'
    autoUpgradeMinorVersion: true
  }
}

resource fluxConfig 'Microsoft.KubernetesConfiguration/fluxConfigurations@2022-11-01' = {
  name: 'cluster-config'
  scope: aks
  dependsOn: [
    fluxExtension
  ]
  properties: {
    scope: 'cluster'
    namespace: 'cluster-config'
    sourceKind: 'GitRepository'
    suspend: false
    gitRepository: {
      url: gitRepoUrl
      timeoutInSeconds: 600
      syncIntervalInSeconds: 600
      repositoryRef: {
        branch: 'main'
      }
    }
    kustomizations: {
      apps: {
        path: './apps/${environmentName}'
        timeoutInSeconds: 600
        syncIntervalInSeconds: 600
        retryIntervalInSeconds: 600
        prune: true
      }
    }
  }
}
