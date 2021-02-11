# EnvironmentVariableItems

## Description
Powershell module with commands to easily add or remove items from 'collection type' Windows environment variables.  For example, adding 'C:\foo' to $env:Path.

## Installation

a) install from PowershellGallery
```
PS> Install-Module EnvironmentVariableItems
```

or b) save from PowershellGallery and install manually, eg.;
```
PS> Save-Module -Name EnvironmentVariableItems -Repository PSGallery -Path C:\testmod
PS> $env:PSModulePath
PS> Copy-Item -r C:\testmod\EnvironmentVariableItems $HOME\Documents\WindowsPowerShell\Modules
```

or c) download from GitHub (https://github.com/a1publishing/Powershell_Module_EnvironmentVariableItems/archive/master.zip) and install manually, eg.;
```
PS> $env:PSModulePath
PS> Copy-Item -r mod\EnvironmentVariableItems $HOME\Documents\WindowsPowerShell\Modules
```


Test EnvironmentVariableItems, eg.;
```
PS> Import-Module EnvironmentVariableItems 
PS> Get-EnvironmentVariableItems -Name PSModulePath
```



## Usage
```
PS> Get-Help Add-EnvironmentVariableItem

NAME
    Add-EnvironmentVariableItem

SYNOPSIS
    Adds an environment variable for given Name, Value, Scope (default: 'Process') and Separator (';') and optional Index.


SYNTAX
    Add-EnvironmentVariableItem [-Name] <String> [-Value] <String> [-Scope {Process | User | Machine}] [-Separator <String>] [-Index
    <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

```
PS> Get-Help Add-EnvironmentVariableItem -Examples
..
..
    -------------------------- EXAMPLE 1 --------------------------

    PS > Add 'C:\foo' to $env:Path variable

    PS> Add-EnvironmentVariableItem -Name path -Value c:\foo -Scope User -WhatIf
    What if:
        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin;c:\foo
```

```
    -------------------------- EXAMPLE 2 --------------------------

    PS > Insert 'C:\foo' as first item in $env:Path variable

    PS> Add-EnvironmentVariableItem -Name path -Value c:\foo -Scope User -Index 0 -WhatIf
    What if:
        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            c:\foo;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
```

```
    -------------------------- EXAMPLE 3 --------------------------

    PS > Insert 'C:\foo' as second last item in $env:Path variable

    PS> Add-EnvironmentVariableItem -Name path -Value c:\foo -Scope User -Index -2 -WhatIf
    What if:
        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;c:\foo;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
```

```
    -------------------------- EXAMPLE 4 --------------------------

    PS > Add 'cake' as last item of $env:foo in current process

    PS> aevi foo cake -separator '#' -whatif
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
    Removes an environment variable for a given Name, Value or Index, Scope (default: 'Process') and Separator (';').


SYNTAX
    Remove-EnvironmentVariableItem [-Name] <String> [-Value] <String> [-Scope {Process | User | Machine}] [-Separator <String>] [-WhatIf]
    [-Confirm] [<CommonParameters>]

    Remove-EnvironmentVariableItem [-Name] <String> [-Index] <Int32> [-Scope {Process | User | Machine}] [-Separator <String>] [-WhatIf]
    [-Confirm] [<CommonParameters>]
```

```
PS> Get-Help Remove-EnvironmentVariableItem -Examples
..
..
    -------------------------- EXAMPLE 1 --------------------------

    PS > Remove 'c:\foo' from $env:Path variable

    PS> Remove-EnvironmentVariableItem -Name path -Value 'c:\foo' -Scope User -WhatIf
    What if:
        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;c:\foo;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
```

```
    -------------------------- EXAMPLE 2 --------------------------

    PS > Remove last item from $env:Path

    PS> Remove-EnvironmentVariableItem -Name path -Scope User -Index -1 -WhatIf
    What if:
        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps
```

```
    -------------------------- EXAMPLE 3 --------------------------

    PS > Show index and remove second item from $env:foo variable in the current process

    PS> (gevis foo -se '#').ShowIndex()

    Machine
    0: mat
    1: mop

    User
    0: foo
    1: cake
    2: bar
    3: cup

    Process
    0: foo
    1: cake
    2: bar
    3: cup


    PS> revi foo -in 1 -se '#'

    Confirm
    Are you sure you want to perform this action?

        Current Value:
            foo#cake#bar#cup
        New value:
            foo#bar#cup

    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y

    Name      : foo
    Scope     : Process
    Separator : #
    Value     : foo#cake#bar#cup
    Items     : {foo, bar, cup}
```

```
PS> Get-Help EnvironmentVariableItems

NAME
    Get-EnvironmentVariableItems

SYNOPSIS
    Gets an EnvironmentVariableItems object for a given Name, Scope (default: 'Process') and Separator (';').


SYNTAX
    Get-EnvironmentVariableItems [-Name] <String> [[-Scope] {Process | User | Machine}] [[-Separator] <String>] [<CommonParameters>]
```

```
PS> Get-Help Get-EnvironmentVariableItems -Examples
..
..
    -------------------------- EXAMPLE 1 --------------------------

    PS > Get current process $env:Path EnvironmentVariableItems object

    PS> Get-EnvironmentVariableItems -Name Path

    Name      : Path
    Scope     : Process
    Separator : ;
    Value     : C:\Program Files\PowerShell\7;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.
                0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files (x86)\ATI
                Technologies\ATI.ACE\Core-Static;C:\ProgramData\chocolatey\bin;C:\Program Files\PowerShell\7\;C:\Program
                Files\Git\cmd;C:\Program Files\Microsoft VS Code\bin;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps
    Items     : {C:\Program Files\PowerShell\7, C:\WINDOWS\system32, C:\WINDOWS, C:\WINDOWS\System32\Wbem…}
```

```
    -------------------------- EXAMPLE 2 --------------------------

    PS > Show index of items in $env:PSModulePath system variable

    PS> (gevis psmodulepath).showindex()

    Machine
    0: C:\Program Files\WindowsPowerShell\Modules
    1: C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
    2: N:\lib\pow\mod

    User
    0: H:\lib\pow\mod

    Process
    0: C:\Users\michaelf\Documents\PowerShell\Modules
    1: C:\Program Files\PowerShell\Modules
    2: c:\program files\powershell\7\Modules
    3: H:\lib\pow\mod
    4: C:\Program Files\WindowsPowerShell\Modules
    5: C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
    6: N:\lib\pow\mod

```


[MIT License (c) 2021](../master/LICENSE) [a1publishing.com](https://www.a1publishing.com)
