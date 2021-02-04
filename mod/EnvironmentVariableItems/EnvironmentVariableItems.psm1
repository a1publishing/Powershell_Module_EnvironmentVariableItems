<#
.SYNOPSIS
Adds an environment variable for given Name, Value, Scope (default; 'Process') and Separator (';') and optional Index.

.EXAMPLE

Add 'C:\foo' to $env:Path variable

PS> Add-EnvironmentVariableItem -Name path -Value c:\foo -Scope User -WhatIf

What if:

    Current Value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
    New value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin;c:\foo

.EXAMPLE

Insert 'C:\foo' as first item in $env:Path variable

PS> Add-EnvironmentVariableItem -Name path -Value c:\foo -Scope User -Index 0 -WhatIf

What if:

    Current Value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
    New value:
        c:\foo;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin

.EXAMPLE

Insert 'C:\foo' as second last item in $env:Path variable

PS> Add-EnvironmentVariableItem -Name path -Value c:\foo -Scope User -Index -2 -WhatIf

What if:

    Current Value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
    New value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;c:\foo;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin

.EXAMPLE

Add 'cake' as last item of $env:foo in current process

PS> Get-EnvironmentVariable -Name foo -Scope User

Name            : foo
Value           : foo#bar#cup
Scope           : User
ValueType       : String
BeforeExpansion :

PS> aevi foo cake -Separator '#' -whatif

What if:
    Current Value:
        foo#bar#cup
    New value:
        foo#bar#cup#cake
#>
function Add-EnvironmentVariableItem {
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
            Position = 1
        )] 
            [String] $Value,        
        [Parameter()]
            [System.EnvironmentVariableTarget] $Scope = [System.EnvironmentVariableTarget]::Process,
        [Parameter()]
            [String] $Separator = ';',
        [Parameter()] 
            [int] $Index
    )    
    process {
        $evis = Get-EnvironmentVariableItems $Name $Scope $Separator

        if ($PSBoundParameters.ContainsKey('Index')) {
            $result = $evis.AddItem($Value, $Index) -ne $False
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
Gets an EnvironmentVariableItems object for a given Name, Scope (default; 'Process') and Separator (';').

.EXAMPLE

Get current process $env:Path EnvironmentVariableItems object

PS> Get-EnvironmentVariableItems -Name Path 

Name      : Path
Scope     : Process
Separator : ;
Value     : C:\Program Files\PowerShell\7;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.
            0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files (x86)\ATI
            Technologies\ATI.ACE\Core-Static;C:\ProgramData\chocolatey\bin;C:\Program Files\PowerShell\7\;C:\Program
            Files\Git\cmd;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS
            Code\bin
Items     : {C:\Program Files\PowerShell\7, C:\WINDOWS\system32, C:\WINDOWS, C:\WINDOWS\System32\Wbem…}

.EXAMPLE

Show index of items in $env:PSModulePath system variable

PS> (gevis PSModulePath -Scope Machine).ShowIndex()

0: C:\Program Files\WindowsPowerShell\Modules
1: C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules
2: N:\lib\pow\mod
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
                    [int] $Index
            )    
            process {
                if ($PSBoundParameters.ContainsKey('Index')) {
                    # Add 1 to items count reflecting length after addition
                    if (($ind = $this.GetPositiveIndex($Index, $this.Items.count + 1)) -is [int]) {
                        $this.Items.insert($ind, $Value)
                    } else {
                        return $False
                    }                    
                } else {
                    $this.Items.add($Value)
                }
            }
         } -Force
        
        # check index is within range and return (as positive value if required)
        $obj | Add-Member ScriptMethod GetPositiveIndex { 
            [CmdletBinding()]
            param (
                [Parameter(
                    Mandatory,
                    Position = 0
                )] 
                    [int] $Index,
                [Parameter(
                    Mandatory,
                    Position = 1
                )] 
                    [int] $ItemsCount
            )

            <#
            $len = $this.Items.count
            if ($Index -le $len -and $(-($Index) -le $len)) {
                if ($Index -lt 0) {
                    $len + $Index
                } else {
                    $Index
                }
            } else {
                Write-Host "Index $Index is out of range"
            }
            #>
            if ($Index -lt $ItemsCount -and $(-($Index) -le $ItemsCount)) {
                if ($Index -lt 0) {
                    $ItemsCount + $Index
                } else {
                    $Index
                }
            } else {
                Write-Host "Index $Index is out of range"
            }
            
            
        } -Force

        $obj | Add-Member ScriptMethod RemoveItemByIndex { 
            [CmdletBinding()]
            param (
                [Parameter(Mandatory)] 
                    [int] $Index
            )    
            process {
                    if (($ind = $this.GetPositiveIndex($Index, $this.Items.count)) -is [int]) {
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
                Write-Host    
                for ($i = 0; $i -lt $this.Items.count; $i++) {
                    Write-Host "${i}: $($this.Items[$i].ToString())"
                }
                Write-Host    
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
Removes an environment variable for given Name, Value and Scope (default; 'Process') and Separator (';') and optional Index.

.EXAMPLE

Remove 'c:\foo' from $env:Path variable

PS> Remove-EnvironmentVariableItem -Name path -Value 'c:\foo' -Scope User -WhatIf

What if:
    Current Value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;c:\foo;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
    New value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin

.EXAMPLE

Remove last item from $env:Path

PS> Remove-EnvironmentVariableItem -Name path -Scope User -Index -1 -WhatIf

What if:

    Current Value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps;C:\Users\michaelf\AppData\Local\Programs\Microsoft VS Code\bin
    New value:
        C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps

.EXAMPLE

Show index and remove third last item from $env:foo variable in the current process

PS> (Get-EnvironmentVariableItems foo -Separator '#').ShowIndex()

0: foo
1: cake
2: bar
3: cup

PS> revi foo -Index -3 -Separator '#' -WhatIf

What if:
    Current Value:
        foo#cake#bar#cup
    New value:
        foo#bar#cup
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
            ParameterSetName = 'ByIndex',
            Position = 1, 
            Mandatory
        )] [int] $Index,
        [Parameter()]
            [System.EnvironmentVariableTarget] $Scope = [System.EnvironmentVariableTarget]::Process,
        [Parameter()] 
            [String] $Separator = ";"

    )    
    process {

        $evis = Get-EnvironmentVariableItems $Name $Scope $Separator

        if ($PSCmdlet.ParameterSetName -eq 'ByIndex') {
            $result = $evis.RemoveItemByIndex($Index) -ne $False
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

New-Alias -Name aevi -Value Add-EnvironmentVariableItem
New-Alias -Name gevis -Value Get-EnvironmentVariableItems
New-Alias -Name revi -Value Remove-EnvironmentVariableItem

Export-ModuleMember -Alias * -Function *