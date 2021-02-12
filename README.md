# EnvironmentVariableItems

## Description
Powershell module with commands to easily add or remove items from 'collection type' Windows environment variables.  For example, adding 'C:\tmp' to $env:Path.

## Installation

a) install from PowershellGallery
```
PS> Install-Module EnvironmentVariableItems
```

or b) save from PowershellGallery and install manually, eg.;
```
PS> Save-Module -Name EnvironmentVariableItems -Repository PSGallery -Path C:\tmp
PS> $env:PSModulePath
PS> Copy-Item -r C:\tmp\EnvironmentVariableItems $HOME\Documents\WindowsPowerShell\Modules
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

### CmdLets
```
PS> Get-Command *-EnvironmentVariableItem*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Add-EnvironmentVariableItem                        1.4.1      environmentvariableitems
Function        Get-EnvironmentVariableItems                       1.4.1      environmentvariableitems
Function        Remove-EnvironmentVariableItem                     1.4.1      environmentvariableitems
Function        Show-EnvironmentVariableItems                      1.4.1      environmentvariableitems

```

### Get-EnvironmentVariableItems
```
PS> Get-Help Get-EnvironmentVariableItems

NAME
    Get-EnvironmentVariableItems

SYNOPSIS
    Gets an EnvironmentVariableItems object for a given Name, Scope (default: 'Process') and Separator (';').


SYNTAX
    Get-EnvironmentVariableItems [-Name] <String> [[-Scope] {Process | User | Machine}] [[-Separator] <String>] [<CommonParameters>]
..    
```

#### Examples
```
PS> Get-Help Get-EnvironmentVariableItems -Examples
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

    PS > Get user $env:Path EnvironmentVariableItems object

    PS> Get-EnvironmentVariableItems -Name Path -Scope User

    Name      : Path
    Scope     : User
    Separator : ;
    Value     : C:\tmp;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps
    Items     : {C:\tmp, C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps}
```

```
    -------------------------- EXAMPLE 3 --------------------------

    PS > Get user $env:foo EnvironmentVariableItems object

    PS> gevis foo -sc user -se '#'

    Name      : foo
    Scope     : User
    Separator : #
    Value     : foo#cake#bar#cup
    Items     : {foo, cake, bar, cup}
```

### Show-EnvironmentVariableItems
```
Get-Help Show-EnvironmentVariableItems

NAME
    Show-EnvironmentVariableItems

SYNOPSIS
    Show indexed list of environment variable items for given Name, Scope and Separator (default: ';').  Omitting Scope parameter shows
    list for all, ie., Machine, User and Process.


SYNTAX
    Show-EnvironmentVariableItems [-Name] <String> [[-Scope] {Process | User | Machine}] [[-Separator] <String>] [-WhatIf] [-Confirm]
    [<CommonParameters>]
..
```

#### Examples
```
PS> Get-Help Show-EnvironmentVariableItems -Examples
..
    -------------------------- EXAMPLE 1 --------------------------

    PS > Show $env:PSModulePath items

    PS> Show-EnvironmentVariableItems PSModulePath

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
```
    -------------------------- EXAMPLE 2 --------------------------

    PS > Show PSModulePath system variable items

    PS> Show-EnvironmentVariableItems PSModulePath -Scope Machine

    Machine
    0: C:\Program Files\WindowsPowerShell\Modules
    1: C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
    2: N:\lib\pow\mod
```
```
    -------------------------- EXAMPLE 3 --------------------------

    PS > Show system, user and process items for $env:TMP environment variable

    PS> Show-EnvironmentVariableItems TMP

    Machine
    0: C:\WINDOWS\TEMP

    User
    0: C:\Users\michaelf\AppData\Local\Temp

    Process
    0: C:\Users\michaelf\AppData\Local\Temp
```

```
    -------------------------- EXAMPLE 4 --------------------------

    PS > Show 'unseparated' system, user and process $env:Path environment variables

    PS> sevis path -se ';;'

Machine
0: C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files (x86)\ATI Technologies\ATI.ACE\Core-Static;C:\ProgramData\chocolatey\bin;C:\Program Files\PowerShell\7\;C:\Program Files\Git\cmd;C:\Program Files\Microsoft VS Code\bin

User
0: C:\tmp;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps

Process
0: C:\Program Files\PowerShell\7;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files (x86)\ATI Technologies\ATI.ACE\Core-Static;C:\ProgramData\chocolatey\bin;C:\Program Files\PowerShell\7\;C:\Program Files\Git\cmd;C:\Program Files\Microsoft VS Code\bin;C:\tmp;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps
```

### Add-EnvironmentVariableItem
```
PS> Get-Help Add-EnvironmentVariableItem

NAME
    Add-EnvironmentVariableItem

SYNOPSIS
    Adds an environment variable item for given Name, Value, Scope (default: 'Process') and Separator (';') and optional Index.


SYNTAX
    Add-EnvironmentVariableItem [-Name] <String> [-Value] <String> [-Scope {Process | User | Machine}] [-Separator <String>] [-Index
    <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
..
```

#### Examples
```
PS> Get-Help Add-EnvironmentVariableItem -Examples
..
    -------------------------- EXAMPLE 1 --------------------------

    PS > Add 'C:\tmp' to $env:Path user environment variable

    PS> Add-EnvironmentVariableItem -Name path -Value C:\tmp -Scope User -WhatIf
    What if:
        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin;C:\tmp
```

```
    -------------------------- EXAMPLE 2 --------------------------

    PS > Insert 'C:\tmp' as first item in $env:Path user environment variable

    PS> Add-EnvironmentVariableItem -Name path -Value C:\tmp -Scope User -Index 0 -WhatIf
    What if:
        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\tmp;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
```

```
    -------------------------- EXAMPLE 3 --------------------------

    PS > Insert 'C:\tmp' as second last item in $env:Path user environment variable

    PS> Add-EnvironmentVariableItem -Name path -Value C:\tmp -Scope Process -Index -2 -WhatIf
What if:
    Current Value:
        C:\Program Files\PowerShell\7;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files (x86)\ATI Technologies\ATI.ACE\Core-Static;C:\ProgramData\chocolatey\bin;C:\Program Files\PowerShell\7\;C:\Program Files\Git\cmd;C:\Program Files\Microsoft VS Code\bin;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps
    New value:
        C:\Program Files\PowerShell\7;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files (x86)\ATI Technologies\ATI.ACE\Core-Static;C:\ProgramData\chocolatey\bin;C:\Program Files\PowerShell\7\;C:\Program Files\Git\cmd;C:\Program Files\Microsoft VS Code\bin;C:\tmp;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps
```

```
    -------------------------- EXAMPLE 4 --------------------------

    PS > Add 'cake' as last item of $env:foo in current process

    PS> aevi foo cake -se '#' -wh
    What if:
        Current Value:
            foo#bar#cup
        New value:
            foo#bar#cup#cake
```

### Remove-EnvironmentVariableItem
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
..    
```

#### Examples
```
PS> Get-Help Remove-EnvironmentVariableItem -Examples
..
    -------------------------- EXAMPLE 1 --------------------------

    PS > Remove 'C:\tmp' from $env:Path user environment variable

    PS> Remove-EnvironmentVariableItem -Name path -Value 'C:\tmp' -Scope User -WhatIf
    What if:
        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\tmp;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
```

```
    -------------------------- EXAMPLE 2 --------------------------

    PS > Remove last item from $env:Path user environment variable

    PS> Remove-EnvironmentVariableItem -Name path -Scope User -Index -1 -WhatIf
    What if:
        Current Value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
        New value:
            C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps
```

```
    -------------------------- EXAMPLE 3 --------------------------

    PS > Remove second item from $env:foo user environment variable

    PS> sevis foo

    Machine
    0: mat#mop

    User
    0: foo#cake#bar#cup

    Process
    0: foo#cake#bar#cup

    PS> sevis foo -sc user -se '#'

    User
    0: foo
    1: cake
    2: bar
    3: cup

    PS> revi foo -in 1 -sc user -se '#'

    Confirm
    Are you sure you want to perform this action?

        Current Value:
            foo#cake#bar#cup
        New value:
            foo#bar#cup
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y

    Name      : foo
    Scope     : User
    Separator : #
    Value     : foo#cake#bar#cup
    Items     : {foo, bar, cup}

    PS> sevis foo

    Machine
    0: mat#mop

    User
    0: foo#bar#cup

    Process
    0: foo#cake#bar#cup

    PS> $env:foo
    foo#cake#bar#cup

    PS> [Environment]::GetEnvironmentVariable('foo', 'User')
    foo#bar#cup

```


[MIT License (c) 2021](../master/LICENSE) [a1publishing.com](https://www.a1publishing.com)
