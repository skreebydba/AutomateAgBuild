param biceplocation string = resourceGroup().location
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: biceplocation
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
}

module appService 'modules/appService.bicep' = {
  name: 'appService'
  params: {
    appServiceAppName: appServiceAppName 
    environmentType: environmentType
    location: biceplocation
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
