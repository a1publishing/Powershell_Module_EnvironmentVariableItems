# A1_EnvironmentVariableItems

## Description
Powershell module allowing handling of environment variable 'items'.  Primarily useful for, though not restricted to, path type variables, eg.; adding 'C:\foo' to $env:Path.

## Installation

1. Install EnvVar, a required (third-party) module. Options include..

a) from PowershellGallery;

```powershell
PS> Install-Module EnvVar -RequiredVersion 0.1.0
Untrusted repository
You are installing the modules from an untrusted repository. If you trust this repository, change its InstallationPolicy value by running
the Set-PSRepository cmdlet. Are you sure you want to install the modules from 'PSGallery'?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): y
```

b) install manually

```powershell
# install
PS> Copy-Item -r mod\EnvVar $HOME\Documents\PowerShell\Modules

# test, eg.;
PS> Import-Module EnvVar # (not strictly required)
PS> Get-EnvironmentVariable path -Scope User
```

2. Install Envir

```powershell
# install
Copy-Item -r mod\EnvironmentVariableItems $HOME\Documents\PowerShell\Modules

# test, eg.;
PS> Import-Module EnvironmentVariableItems # (not strictly required)
PS> Get-EnvironmentVariableItems path -Scope User
```



## Usage

```powershell
PS> get-help Get-EnvironmentVariableItem -Examples
..
PS> get-help Add-EnvironmentVariableItem -Examples
..
PS> get-help Remove-EnvironmentVariableItem -Examples
```




[MIT License (c) 2019 a1publishing](LICENSE)
