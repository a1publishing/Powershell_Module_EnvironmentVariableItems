# EnvVar

[![Build Status](https://dev.azure.com/mytgnq/pwsh-EnvVar/_apis/build/status/GNQG.pwsh-EnvVar?branchName=master)](https://dev.azure.com/mytgnq/pwsh-EnvVar/_build/latest?definitionId=1&branchName=master)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/EnvVar)](https://www.powershellgallery.com/packages/EnvVar/)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/p/EnvVar)](https://www.powershellgallery.com/packages/EnvVar/)

A PowerShell module to handle environment variables,  supporting variable expansion.

## Install

```powershell
Install-Module EnvVar
```

## Usage

```powershell
PS> Import-Module EnvVar
PS> $var = Get-EnvironmentVariable -Name SOME_ENVVAR -Scope Process
PS> $var
# returns a custom object
#
# Name            : SOME_ENVVAR
# Value           : some_value
# Scope           : Process
# ValueType       : String
# BeforeExpansion :

PS> "$var" -eq "some_value"
# True (`ToString` method is overridden)

PS> Set-EnvironmentVariable -Name NEW_ENVVAR -Value new_value -Scope User -ValueType String -Inherit Auto
# sets an environment variable
# returns the result of `Get-EnvironmentVariable NEW_ENVVAR`
#
# Name            : NEW_ENVVAR
# Value           : new_value
# Scope           : User
# ValueType       : String
# BeforeExpansion :

PS> Set-EnvironmentVariable -Name EXPANDED -Value 'expanded: %NEW_ENVVAR%' -Scope User -ValueType ExpandString -Inherit Auto
# set an environment variable as ExpandString
#
# Name            : EXPANDED
# Value           : expanded: new_value
# Scope           : User
# ValueType       : ExpandString
# BeforeExpansion : expanded: %NEW_ENVVAR%
```

## License

[MIT License (c) 2019 @GNQG](LICENSE)
