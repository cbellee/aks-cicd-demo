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

resource fluxExtension 'Microsoft.KubernetesConfiguration/extensions@2022-07-01' = {
  name: 'flux'
  scope: aks
  properties: {
    extensionType: 'microsoft.flux'
    autoUpgradeMinorVersion: true
  }
}

resource fluxConfig 'Microsoft.KubernetesConfiguration/fluxConfigurations@2022-07-01' = {
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
      timeoutInSeconds: 60
      syncIntervalInSeconds: 60
      repositoryRef: {
        branch: 'main'
      }
    }
    kustomizations: {
      infra: {
        path: './infrastructure'
        syncIntervalInSeconds: 120
      }
      apps: {
        path: './apps/${environmentName}'
        timeoutInSeconds: 60
        syncIntervalInSeconds: 60
        retryIntervalInSeconds: 60
        prune: true
        dependsOn: [
          'infra'
        ]
      }
    }
  }
}
