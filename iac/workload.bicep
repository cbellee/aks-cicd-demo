param environment string
param clusterName string
param gitRepoUrl string

/* resource existingCluster 'Microsoft.ContainerService/managedClusters@2022-10-02-preview' existing = {
  name: clusterName
} */

/* module fluxExtension './modules/flux-extension.bicep' = {
  name: 'module-flux'
  params: {
    aksClusterName: existingCluster.name
    gitRepoUrl: gitRepoUrl
    environmentName: environment
  }
} */

resource aks 'Microsoft.ContainerService/managedClusters@2022-10-02-preview' existing = {
  name: clusterName
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
        path: './apps/${environment}'
        timeoutInSeconds: 600
        syncIntervalInSeconds: 600
        retryIntervalInSeconds: 600
        prune: true
      }
    }
  }
}

output clusterName string = aks.name
