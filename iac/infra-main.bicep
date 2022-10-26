param tags object
param location string
param vNets array
param environment string
param networkResourceGroupName string = '${environment}-network-rg'
param monitorResourceGroupName string = '${environment}-monitor-rg'
param workloadResourceGroupName string = '${environment}-workload-rg'

targetScope = 'subscription'

resource networkResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: networkResourceGroupName
}

resource monitorResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: monitorResourceGroupName
}

resource workloadResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: workloadResourceGroupName
}

// Azure Monitor Workspace
module azMonitorModule './modules/azmon.bicep' = {
  scope: resourceGroup(monitorResourceGroup.name)
  name: 'modules-azmon'
  params: {
    location: location
  }
}

// Virtual Networks
module vNetsModule './modules/vnets.bicep' = [for (item, i) in vNets: {
  scope: resourceGroup(networkResourceGroup.name)
  name: 'module-vnet-${i}'
  params: {
    location: location
    vNet: item
    tags: tags
  }
}]

// Virtual Network Peering
module peeringModule './modules/peering.bicep' = {
  scope: resourceGroup(networkResourceGroup.name)
  name: 'module-peering'
  params: {
    vNets: vNets
    isGatewayDeployed: false
  }
  dependsOn: [
    vNetsModule
  ]
}

output aksSystemSubnetId string = vNetsModule[1].outputs.subnetRefs[0].id
output aksUserSubnetId string = vNetsModule[1].outputs.subnetRefs[1].id
output networkResourceGroupName string = networkResourceGroup.name
output monitorResourceGroupName string = monitorResourceGroup.name
output workloadResourceGroupName string = workloadResourceGroup.name
output azMonitorWorkspaceId string = azMonitorModule.outputs.workspaceId
