# EnvironmentVariableItems

## Description
Powershell module with commands to easily add or remove items from 'collection type' Windows Environment Variables.  For example, add 'C:\foo' to $env:Path.

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
PS> Get-Help Add-EnvironmentVariableItem

NAME
    Add-EnvironmentVariableItem

SYNOPSIS
    Adds an environment variable for given Name, Value, Scope (default; 'Process') and Separator (';') and optional Index.


SYNTAX
    Add-EnvironmentVariableItem [-Name] <String> [-Value] <String> [-Scope {Process | User | Machine}] [-Separator <String>] [-Index
    <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

```
PS> Get-Help Add-EnvironmentVariableItem -Examples
..
    -------------------------- EXAMPLE 1 --------------------------

    PS > Add 'C:\foo' to $env:Path variable

    PS> Add-EnvironmentVariableItem -Name path -Value c:\foo -Scope User -WhatIf

    What if:

        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin;c:\foo




    -------------------------- EXAMPLE 2 --------------------------

    PS > Insert 'C:\foo' as first item in $env:Path variable

    PS> Add-EnvironmentVariableItem -Name path -Value c:\foo -Scope User -Index 0 -WhatIf

    What if:

        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            c:\foo;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin




    -------------------------- EXAMPLE 3 --------------------------

    PS > Insert 'C:\foo' as second last item in $env:Path variable

    PS> Add-EnvironmentVariableItem -Name path -Value c:\foo -Scope User -Index -2 -WhatIf

    What if:

        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;c:\foo;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin




    -------------------------- EXAMPLE 4 --------------------------

    PS > Add 'cake' as last item of $env:foo in current process

    PS> aevi foo cake -Separator '#' -whatif

    What if:
        Current Value:
            foo#bar#cup
        New value:
            foo#bar#cup#cake
```

```
PS> Get-Help Remove-EnvironmentVariableItem

NAME
    Remove-EnvironmentVariableItem

SYNOPSIS
    Removes an environment variable for a given Name, Value or Index, Scope (default; 'Process') and Separator (';').


SYNTAX
    Remove-EnvironmentVariableItem [-Name] <String> [-Value] <String> [-Scope {Process | User | Machine}] [-Separator <String>] [-WhatIf]
    [-Confirm] [<CommonParameters>]

    Remove-EnvironmentVariableItem [-Name] <String> [-Index] <Int32> [-Scope {Process | User | Machine}] [-Separator <String>] [-WhatIf]
    [-Confirm] [<CommonParameters>]
```

```
PS> Get-Help Remove-EnvironmentVariableItem -Examples
..
    -------------------------- EXAMPLE 1 --------------------------

    PS > Remove 'c:\foo' from $env:Path variable

    PS> Remove-EnvironmentVariableItem -Name path -Value 'c:\foo' -Scope User -WhatIf

    What if:
        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;c:\foo;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin




    -------------------------- EXAMPLE 2 --------------------------

    PS > Remove last item from $env:Path

    PS> Remove-EnvironmentVariableItem -Name path -Scope User -Index -1 -WhatIf

    What if:

        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps




    -------------------------- EXAMPLE 3 --------------------------

    PS > Show index and remove second last item from $env:foo variable in the current process

    PS> (gevis foo -Separator '#').ShowIndex()

    0: foo
    1: cake
    2: bar
    3: cup

    PS> revi foo -Index -2 -Separator '#' -WhatIf

    What if:
        Current Value:
            foo#cake#bar#cup
        New value:
            foo#bar#cup
```

```
PS> Get-Help EnvironmentVariableItems

NAME
    Get-EnvironmentVariableItems

SYNOPSIS
    Gets an EnvironmentVariableItems object for a given Name, Scope (default; 'Process') and Separator (';').


SYNTAX
    Get-EnvironmentVariableItems [-Name] <String> [[-Scope] {Process | User | Machine}] [[-Separator] <String>] [<CommonParameters>]
```

```
PS> Get-Help Get-EnvironmentVariableItems -Examples
..
    -------------------------- EXAMPLE 1 --------------------------

    PS > Get current process $env:Path EnvironmentVariableItems object

    PS> Get-EnvironmentVariableItems -Name Path

    Name      : Path
    Scope     : Process
    Separator : ;
    Value     : C:\Program
    Files\PowerShell\7;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.
                0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files (x86)\ATI
                Technologies\ATI.ACE\Core-Static;C:\ProgramData\chocolatey\bin;C:\Program Files\PowerShell\7\;C:\Program
                Files\Git\cmd;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS
                Code\bin
    Items     : {C:\Program Files\PowerShell\7, C:\WINDOWS\system32, C:\WINDOWS, C:\WINDOWS\System32\Wbem…}




    -------------------------- EXAMPLE 2 --------------------------

    PS > Show index of items in $env:PSModulePath system variable

    PS> (gevis PSModulePath -Scope Machine).ShowIndex()

    0: C:\Program Files\WindowsPowerShell\Modules
    1: C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
    2: N:\lib\pow\mod

```


[MIT License (c) 2021 a1publishing.com] (LICENSE)
