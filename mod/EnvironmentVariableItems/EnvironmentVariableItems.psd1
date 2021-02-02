@{
RootModule = 'EnvironmentVariableItems.psm1'
ModuleVersion = '1.0.3'
GUID = 'f5ed8644-7f61-49cb-b4e5-fe24e5e85262'
Author = 'a1publishing\michaelf'
CompanyName = 'a1publishing.com'
Copyright = '(c) a1publishing.com'
Description = 'Module allowing handling of environment variable "items". Primarily useful for, though not restricted to, path type variables, eg.; adding "C:\foo" to $env:Path.'
PowerShellVersion = '3.0'
RequiredModules = @('EnvVar')
FunctionsToExport = @('Add-EnvironmentVariableItem', 'Get-EnvironmentVariableItems', 'Remove-EnvironmentVariableItem')
AliasesToExport = @('aevi', 'gevis', 'revi')
PrivateData = @{
    PSData = @{
        Tags = @('Environment', 'Variable', 'items', 'path', 'PSModulePath', 'split')
        LicenseUri = 'https://github.com/mikecflynn/Powershell_Module_EnvironmentVariableItems/blob/master/LICENSE'
        ProjectUri = 'https://github.com/mikecflynn/Powershell_Module_EnvironmentVariableItems'
    } 
}
}
