targetScope = 'subscription'

param rgName string = 'iac-training-rg-2'
param location string = 'eastus'
param storageAccountName string
param uniqueIdentifier string
param environment string
param containerName string

resource storageResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgName
  location: location
}

module storageAccount '../storageAccount/storageAccount.bicep' = {
  name: 'storageAccount'
  scope: storageResourceGroup
  params: {
    storageAccountName: storageAccountName
    uniqueIdentifier: uniqueIdentifier
    environment: environment
    location: location
  }
}

module storageAccountContainer '../storageAccount/storageAccountContainer.bicep' = {
  name: 'storageAccountContainer-${containerName}'
  scope: storageResourceGroup
  params: {
    storageAccountFullName: storageAccount.outputs.storageAccountName
    containerName: containerName
  }
}
