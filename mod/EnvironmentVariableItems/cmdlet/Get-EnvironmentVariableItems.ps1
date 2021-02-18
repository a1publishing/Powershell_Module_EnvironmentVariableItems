<#
.SYNOPSIS
Gets an EnvironmentVariableItems PSCustomObject for a given Name, Scope (default; 'Process') and Separator (';').

.PARAMETER Name
Environment variable name

.PARAMETER Scope
Environment variable scope  (.NET enum System.EnvironmentVariableTarget)

.PARAMETER Separator
Environment variable item separator (eg., ';' in $env:Path of 'C:\foo;C:\bar')

.EXAMPLE

Get current process $env:Path EnvironmentVariableItems PSCustomObject

PS> Get-EnvironmentVariableItems -Name Path 

Name      : Path
Scope     : Process
Separator : ;
Value     : C:\Program Files\PowerShell\7;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.
            0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files (x86)\ATI
            Technologies\ATI.ACE\Core-Static;C:\ProgramData\chocolatey\bin;C:\Program Files\PowerShell\7\;C:\Program
            Files\Git\cmd;C:\Program Files\Microsoft VS Code\bin;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps
Items     : {C:\Program Files\PowerShell\7, C:\WINDOWS\system32, C:\WINDOWS, C:\WINDOWS\System32\Wbem…}

.EXAMPLE

Get user $env:Path EnvironmentVariableItems PSCustomObject

PS> Get-EnvironmentVariableItems -Name Path -Scope User

Name      : Path
Scope     : User
Separator : ;
Value     : C:\tmp;C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps
Items     : {C:\tmp, C:\Users\michaelf\AppData\Local\Microsoft\WindowsApps}

.EXAMPLE

Get user $env:foo EnvironmentVariableItems PSCustomObject

PS> gevis foo -sc user -se '#'

Name      : foo
Scope     : User
Separator : #
Value     : foo#cake#bar#cup
Items     : {foo, cake, bar, cup}

.INPUTS

.OUTPUTS
EnvironmentVariableItems PSCustomObject
#>
function Get-EnvironmentVariableItems {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
            [String] $Name,
        [Parameter()]
            #[System.EnvironmentVariableTarget] $Scope = [System.EnvironmentVariableTarget]::Process,
            [System.EnvironmentVariableTarget] $Scope,
        [Parameter()]
            [String] $Separator = ';'
    )    
    process {

        # preserve user provided Scope value before setting default
        $Script:ScopePreDefault = $Scope
        if ($null -eq $Scope) {
            $Scope = [System.EnvironmentVariableTarget]::Process
        } 

        $evis = New-EnvironmentVariableItems-Object $Name $Scope $Separator
        $evis.Value = $evis.GetEnvironmentVariable($Name, $Scope)
        $evis.SetItems($Name, $Scope, $Separator)

        $foo = [EnvironmentVariableItems]::new()



        $evis
    }
}
