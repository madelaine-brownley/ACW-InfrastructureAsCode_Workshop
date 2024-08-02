targetScope = 'subscription'

param rgName string
param location string

@minLength(11)
@maxLength(11)
@description('YYYYMMDD with your initials to follow (i.e. 20291231acw)')
param uniqueIdentifier string

param sqlServerName string
param sqlDatabaseName string
param sqlServerAdminLogin string
@secure()
param sqlServerAdminPassword string
param clientIPAddress string
param logAnalyticsWorkspaceName string

resource contactWebResourceGroup 'Microsoft.Resources/resourceGroups@2018-05-01' = {
  name: rgName
  location: location
}

module contactWebDatabase 'azureSQL.bicep' = {
  name: '${sqlServerName}-${sqlDatabaseName}-${uniqueIdentifier}'
  scope: contactWebResourceGroup
  params: {
    location: contactWebResourceGroup.location
    uniqueIdentifier: uniqueIdentifier
    sqlServerName: sqlServerName
    sqlDatabaseName: sqlDatabaseName
    sqlServerAdminLogin: sqlServerAdminLogin
    sqlServerAdminPassword: sqlServerAdminPassword
    clientIPAddress: clientIPAddress
  }
}

module contactWebAnalyticsWorkspace 'logAnalyticsWorkspace.bicep' = {
  name: '$logAnalyticsWorkspaceName'
  scope: contactWebResourceGroup
  params: {
    location: contactWebResourceGroup.location
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
  }
}
