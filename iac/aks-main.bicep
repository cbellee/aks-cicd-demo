param tags object
param location string
param resourceGroupName string
param aksSystemSubnetId string
param aksUserSubnetId string
param aksAdminGroupObjectId string
param aksVersion string
param azMonitorWorkspaceId string

targetScope = 'subscription'

// Azure Kubernetes Service
module aks './modules/aks.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'module-aks'
  params: {
    location: location
    aksVersion: aksVersion
    zones: []
    tags: tags
    addOns: {}
    enablePrivateCluster: false
    aksSystemSubnetId: aksSystemSubnetId
    aksUserSubnetId: aksUserSubnetId
    logAnalyticsWorkspaceId: azMonitorWorkspaceId
    adminGroupObjectID: aksAdminGroupObjectId
  }
}

output clusterName string = aks.outputs.aksClusterName
output resourceGroupName string = aks.outputs.resourceGroupName
