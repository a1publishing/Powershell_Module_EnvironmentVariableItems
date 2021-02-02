# EnvironmentVariableItems

## Description
Powershell module allowing handling of environment variable 'items'.  Primarily useful for, though not restricted to, path type variables, eg.; adding 'C:\foo' to $env:Path.

## Installation

### Install EnvVar, a required (third-party) module. Options include..
a) from PowershellGallery;
```
PS> Install-Module EnvVar -RequiredVersion 0.1.0
Untrusted repository
You are installing the modules from an untrusted repository. If you trust this repository, change its InstallationPolicy value by running
the Set-PSRepository cmdlet. Are you sure you want to install the modules from 'PSGallery'?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): y
```

or b) install manually, eg.;
```
PS> Copy-Item -r mod\EnvVar $HOME\Documents\PowerShell\Modules
```

Test EnvVar installation, eg.;
```
PS> Import-Module EnvVar # (not strictly required)
PS> Get-EnvironmentVariable path -Scope User
```

### Install EnvironmentVariableItems module

a) from PowershellGallery;
```
PS> Install-Module EnvironmentVariableItems
```

or b) install manually, eg.;
```
PS> Copy-Item -r mod\EnvironmentVariableItems $HOME\Documents\PowerShell\Modules
```

Test EnvironmentVariableItems, eg.;
```
PS> Import-Module EnvironmentVariableItems # (not strictly required)
PS> Get-EnvironmentVariableItems -Name PSModulePath
```



## Usage
```
PS> Get-Help Get-EnvironmentVariableItems -Examples

    -------------------------- EXAMPLE 1 --------------------------

    PS > Get machine's $env:Path EnvironmentVariableItems object

    PS> Get-EnvironmentVariableItems -Name Path -Scope Machine

    Name      : Path
    Scope     : Machine
    Separator : ;
    Value     :
    C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH
                \;C:\Program Files (x86)\ATI Technologies\ATI.ACE\Core-Static;C:\ProgramData\chocolatey\bin;C:\Program
                Files\PowerShell\7\;C:\Program Files\Git\cmd
    Items     : {C:\WINDOWS\system32, C:\WINDOWS, C:\WINDOWS\System32\Wbem, C:\WINDOWS\System32\WindowsPowerShell\v1.0\…}




    -------------------------- EXAMPLE 2 --------------------------

    PS > Show index of $env:PSModulePath items

    PS> (gevis PSModulePath).ShowIndex()

    0: C:\Users\michaelf\Documents\PowerShell\Modules
    1: C:\Program Files\PowerShell\Modules
    2: c:\program files\powershell\7\Modules
    3: H:\lib\pow\mod
    4: C:\Program Files\WindowsPowerShell\Modules
    5: C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
    6: N:\lib\pow\mod


PS> Get-Help Add-EnvironmentVariableItem -Examples

    -------------------------- EXAMPLE 1 --------------------------

    PS > Insert 'C:\foo' as the last but one item in $env:Path variable

    PS> Add-EnvironmentVariableItem -Name path -Value c:\foo -Scope User -Position -1 -WhatIf

    What if:
        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;c:\foo;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin




    -------------------------- EXAMPLE 2 --------------------------

    PS > Add 'cake' as last item of $env:foo

    PS> aevi foo cake -Scope User -Separator '#' -whatif

    What if:
        Current Value:
            foo#bar#cup
        New value:
            foo#bar#cup#cake


PS> Get-Help Remove-EnvironmentVariableItem -Examples

    -------------------------- EXAMPLE 1 --------------------------

    PS > Remove 'c:\foo' from $env:Path variable

    PS> Remove-EnvironmentVariableItem -Name path -Value 'c:\foo' -Scope User -WhatIf

    What if:
        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;c:\foo;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin




    -------------------------- EXAMPLE 2 --------------------------

    PS > Show index and remove item from  $env:foo variable

    PS> (Get-EnvironmentVariableItems -Name foo -Scope User -Separator '#').ShowIndex()

    0: foo
    1: cake
    2: bar
    3: cup

    PS> revi foo 1 -Scope User -Separator '#' -WhatIf

    What if:
        Current Value:
            foo#cake#bar#cup
        New value:
            foo#bar#cup

```




[MIT License (c) 2021 a1publishing.com] (LICENSE)
