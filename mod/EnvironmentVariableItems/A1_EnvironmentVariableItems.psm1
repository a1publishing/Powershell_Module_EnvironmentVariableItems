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
