<#
.SYNOPSIS
Adds an environment variable for given name, value and scope (default, 'process') and separator (';') and optional position.

.EXAMPLE

Insert 'C:\foo' as the last but one item in $env:Path variable

PS> Add-EnvironmentVariableItem -Name path -Value c:\foo -Scope User -Position -1 -WhatIf

What if:
    Current Value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
    New value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;c:\foo;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin

.EXAMPLE

Add 'cake' as last item of $env:foo

PS> Add-EnvironmentVariableItem -Name foo -Value cake -Scope User -Separator '#' -whatif

What if:
    Current Value:
        foo#bar#cup
    New value:
        foo#bar#cup#cake
#>
function Add-EnvironmentVariableItem {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    param (
        [Parameter(
            Mandatory,
            Position = 0
        )]
            [ValidatePattern("[^=]+")]
            [String] $Name,        
        [Parameter(
            Mandatory,
            Position = 1
        )] 
            [String] $Value,        
        [Parameter()]
            [System.EnvironmentVariableTarget] $Scope = [System.EnvironmentVariableTarget]::Process,
        [Parameter()]
            [String] $Separator = ';',
        [Parameter()] 
            [int] $Position
    )    
    process {
        $evis = Get-EnvironmentVariableItems $Name $Scope $Separator

        if ($PSBoundParameters.ContainsKey('Position')) {
            $result = $evis.AddItem($Value, $Position) -ne $False
        } else {
            $result = $evis.AddItem($Value) -ne $False
        }

        if ($result -ne $False) {
            $s = GetWhatIf
            if ($PSCmdlet.ShouldProcess($s, '', '')){
                $evis.UpdateEnvironmentVariable()
                $evis
            }
        } else { 
            return
        }
    }
}

<#
.SYNOPSIS
Gets an 'environment variable items' object for a given name, scope (default, 'process') and separator (';').

.EXAMPLE

Get $env:Path EnvironmentVariableItems object

PS>Get-EnvironmentVariableItems -Name Path -Scope Machine

Name      : Path
Scope     : Machine
Separator : ;
Value     : C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH
            \;C:\Program Files (x86)\ATI Technologies\ATI.ACE\Core-Static;C:\ProgramData\chocolatey\bin;C:\Program
            Files\PowerShell\7\;C:\Program Files\Git\cmd
Items     : {C:\WINDOWS\system32, C:\WINDOWS, C:\WINDOWS\System32\Wbem, C:\WINDOWS\System32\WindowsPowerShell\v1.0\…}

.EXAMPLE
Show index of items in $env:PSModulePath

PS>(Get-EnvironmentVariableItems -Name Path -Scope Machine).ShowIndex()

0: C:\WINDOWS\system32
1: C:\WINDOWS
2: C:\WINDOWS\System32\Wbem
3: C:\WINDOWS\System32\WindowsPowerShell\v1.0\
4: C:\WINDOWS\System32\OpenSSH\
5: C:\Program Files (x86)\ATI Technologies\ATI.ACE\Core-Static
6: C:\ProgramData\chocolatey\bin
7: C:\Program Files\PowerShell\7\
8: C:\Program Files\Git\cmd

#>
function Get-EnvironmentVariableItems {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
            [String] $Name,
        [Parameter()]
            [System.EnvironmentVariableTarget] $Scope = [System.EnvironmentVariableTarget]::Process,
        [Parameter()]
            [String] $Separator = ';'
    )    
    process {
        New-EnvironmentVariableItems-Object $Name $Scope $Separator
    }
}

function GetWhatIf() {
    @"

    Current Value: 
        $((Get-EnvironmentVariable -Name $Name -Scope $Scope).ToString())
    New value: 
        $($evis.ToString())
"@
}

function New-EnvironmentVariableItems-Object {
    param (
        [Parameter(Mandatory)]
            [String] $Name,
        [Parameter()]
            [System.EnvironmentVariableTarget] $Scope = [System.EnvironmentVariableTarget]::Process,
        [Parameter()]
            [String] $Separator = ';'
    )
    process {
        $value = (Get-EnvironmentVariable -Name $Name -Scope $Scope).Value
        $items = $value -split $Separator

        $obj = [PSCustomObject]@{
            Name    = $Name
            Scope   = $Scope
            Separator = $Separator
            Value   = $Value
            Items   = [System.Collections.ArrayList] $items
        }

        $obj | Add-Member ScriptMethod AddItem { 
            [CmdletBinding()]
            param (
                [Parameter(
                    Mandatory,
                    Position = 0
                )] 
                    [String] $Value,        
                [Parameter()] 
                    [int] $Position
            )    
            process {
                if ($PSBoundParameters.ContainsKey('Position')) {
                    if (($ind = $this.GetIndexByPosition($Position)) -is [int]) {
                        $this.Items.insert($ind, $Value)
                    } else {
                        return $False
                    }                    
                } else {
                    $this.Items.add($Value)
                }
            }
         } -Force
        
        # method returns actual index value (negative value counts back through array) unless 'Position' is out of range
        $obj | Add-Member ScriptMethod GetIndexByPosition { 
            [CmdletBinding()]
            param (
                [Parameter(
                    Mandatory,
                    Position = 0
                )] 
                    [int] $Position
            )

            $len = $this.Items.count
            if ($Position -lt $len -and $(-($Position) -le $len)) {
                if ($Position -lt 0) {
                    $len + $Position
                } else {
                    $Position
                }
            } else {
                Write-Host "Position $Position is out of range"
            }
        } -Force

        $obj | Add-Member ScriptMethod RemoveItemByPosition { 
            [CmdletBinding()]
            param (
                [Parameter(Mandatory)] 
                    [int] $Position
            )    
            process {
                    if (($ind = $this.GetIndexByPosition($Position)) -is [int]) {
                        $this.Items.RemoveAt($ind)
                    } else {
                        return $False
                    }                    
            }
         } -Force
        
         $obj | Add-Member ScriptMethod RemoveItemByValue { 
            [CmdletBinding()]
            param (
                [Parameter(
                    Mandatory,
                    Position = 0
                )] 
                    [String] $Value
            )    
            process {
                if (($this.Items.IndexOf($Value)) -ge 0) {
                    $this.Items.Remove($Value)
                } else {
                    Write-Host "Value $Value not found"
                    return $False
                }                    
            }
         } -Force
        
        $obj | Add-Member ScriptMethod ShowIndex { 
            process {
                for ($i = 0; $i -lt $this.Items.count; $i++) {
                    Write-Host "${i}: $($this.Items[$i].ToString())"
                }
                Write-Host    
            }
         } -Force

         $obj | Add-Member ScriptMethod ToString { 
            $s = ''
            for ($i = 0; $i -lt $this.Items.count; $i++) {
                if ($i) { $s += $this.Separator}
                $s += $this.Items[$i]
            }
            $s
         } -Force

         $obj | Add-Member ScriptMethod UpdateEnvironmentVariable { 
            $this.Value = $this.ToString()
            Set-EnvironmentVariable -Name $this.Name -value $this.Value -scope $this.Scope | Out-Null
         } -Force

        return $obj
    }
}

<#
.SYNOPSIS
Adds an environment variable for given name, value and scope (default, 'process') and separator (';') and optional position.

.EXAMPLE

Remove 'C:\foo' from $env:Path variable

PS> Remove-EnvironmentVariableItem -Name path -Value 'c:\foo' -Scope User -WhatIf

What if:
    Current Value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;c:\foo;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
    New value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin

.EXAMPLE

Show index and remove item from  $env:Path variable

PS> (Get-EnvironmentVariableItems -Name Path -Scope User).ShowIndex()

0: C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps
1: c:\foo
2: C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin

PS> Remove-EnvironmentVariableItem -Name path -Position 1 -Scope User -WhatIf

What if:
    Current Value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;c:\foo;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
    New value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
#>
function Remove-EnvironmentVariableItem {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    param (
        [Parameter(
            Mandatory,
            Position = 0
        )]
            [ValidatePattern("[^=]+")]
            [String] $Name,        
        [Parameter(
            Mandatory,
            ParameterSetName = 'ByValue',
            Position = 1 
        )] 
            [String] $Value,        
        [Parameter(
            ParameterSetName = 'ByPosition',
            Position = 1, 
            Mandatory
        )] [int] $Position,
        [Parameter()]
            [System.EnvironmentVariableTarget] $Scope = [System.EnvironmentVariableTarget]::Process,
        [Parameter()] 
            [String] $Separator = ";"

    )    
    process {

        $evis = Get-EnvironmentVariableItems $Name $Scope $Separator

        if ($PSCmdlet.ParameterSetName -eq 'ByPosition') {
            $result = $evis.RemoveItemByPosition($Position) -ne $False
        } elseif ($PSCmdlet.ParameterSetName -eq 'ByValue') {
            $result = $evis.RemoveItemByValue($Value) -ne $False
        }

        if ($result -ne $False) {
            $s = GetWhatIf
            if ($PSCmdlet.ShouldProcess($s, '', '')){

                #Set-EnvironmentVariable -Name $Name -value $evis.ToString() -scope $Scope | Out-Null
                $evis.UpdateEnvironmentVariable()

                $evis
            }
        } else { 
            return
        }


    }
}
