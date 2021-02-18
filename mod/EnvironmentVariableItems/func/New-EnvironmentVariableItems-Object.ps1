function New-EnvironmentVariableItems-Object {
    param (
        [String] $Name,
        [System.EnvironmentVariableTarget] $Scope = [System.EnvironmentVariableTarget]::Process,
        [String] $Separator = ';'
    )
    process {
        $obj = [PSCustomObject]@{}

        $obj | Add-Member ScriptMethod AddItem { 
            param (
                [String] $Item,        
                [int] $Index
            )    
            process {
                if ($PSBoundParameters.ContainsKey('Index')) {
                    # Add 1 to items count reflecting length after addition
                    if (($ind = $this.GetPositiveIndex($Index, $this.Items.count + 1)) -is [int]) {
                        $this.Items.insert($ind, $Item)
                        return $True
                    }                    
                } else {
                    $this.Items.add($Item)
                    return $True
                }
            }
         } -Force
        
         $obj | Add-Member ScriptMethod GetEnvironmentVariable { 
            param (
                [String] $Name,        
                [System.EnvironmentVariableTarget] $Scope = [System.EnvironmentVariableTarget]::Process
            )
            process {
                [Environment]::GetEnvironmentVariable($Name, $Scope)
            }
         }

         $obj | Add-Member ScriptMethod GetItems { 
            param (
                [String] $Name,
                [System.EnvironmentVariableTarget] $Scope = [System.EnvironmentVariableTarget]::Process,
                [String] $Separator = ';'
            )
            process {
                $value = $this.GetEnvironmentVariable($Name, $Scope)

                if ($null -ne $value) {$value = $value.Trim($Separator)}
        
                $items = @()
                if ($null -ne $value) {        
                    $items = $value -split $Separator
                }

                $items
            }
         }
            
         # check index is within range and return (as positive value if required)
        $obj | Add-Member ScriptMethod GetPositiveIndex { 
            param (
                [int] $Index,
                [int] $ItemsCount
            )

            if ($Index -lt $ItemsCount -and $(-($Index) -le $ItemsCount)) {
                if ($Index -lt 0) {
                    $ItemsCount + $Index
                } else {
                    $Index
                }
            } else {
                Write-Host
                Write-Host  -ForegroundColor Red "Index $Index is out of range"
                Write-Host
            }
            
        } -Force

        $obj | Add-Member ScriptMethod RemoveItemByIndex { 
            param (
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
        
         $obj | Add-Member ScriptMethod RemoveItemByItem { 
            param (
                [String] $Item
            )    
            process {
                if (($this.Items.IndexOf($Item)) -ge 0) {
                    $this.Items.Remove($Item)
                } else {
                    Write-Host
                    Write-Host  -ForegroundColor Red "Item $Item not found"
                    Write-Host
                    return $False
                }                    
            }
         } -Force

         $obj | Add-Member ScriptMethod SetItems { 
            param (
                [String] $Name = $this.Name,
                [System.EnvironmentVariableTarget] $Scope = $this.Scope,
                [String] $Separator = $this.Separator
            )
            process {
                $this.Items = [System.Collections.ArrayList] @($this.GetItems($Name, $Scope, $Separator))
            }
         }

        $obj | Add-Member ScriptMethod ShowIndex { 

            process {
                Write-Host 
                if ($null -eq $Script:ScopePreDefault) {
                    $this.ShowIndexForScope([System.EnvironmentVariableTarget]::Machine)
                    $this.ShowIndexForScope([System.EnvironmentVariableTarget]::User)
                    $this.ShowIndexForScope([System.EnvironmentVariableTarget]::Process)
                } else {
                    $this.ShowIndexForScope($this.Scope)
                }
                Write-Host
                Write-Host
            }
         } -Force

         $obj | Add-Member ScriptMethod ShowIndexForScope { 
            param (
                [System.EnvironmentVariableTarget] $Scope
            )
            process {
                Write-Host $Scope
                $items = @($this.GetItems($this.Name, $Scope, $this.Separator))
                for ($i = 0; $i -lt $items.count; $i++) {
                    Write-Host -ForegroundColor Blue "${i}: $($items[$i].ToString())"
                }
                Write-Host
            }
         } -Force



         $obj | Add-Member ScriptMethod SetEnvironmentVariable { 
            param (
                [String] $Name,        
                [String] $Value,        
                [System.EnvironmentVariableTarget] $Scope = [System.EnvironmentVariableTarget]::Process
            )
            process {
                [Environment]::SetEnvironmentVariable($Name, $Value, $Scope)
                $this.Value = $Value
            }
         }

         $obj | Add-Member ScriptMethod ToString { 
            $s = ''
            for ($i = 0; $i -lt $this.Items.count; $i++) {
                if ($i) { $s += $this.Separator}
                $s += $this.Items[$i]
            }
            $s
         } -Force

         $obj | Add-Member -NotePropertyName Name -NotePropertyValue $Name
         $obj | Add-Member -NotePropertyName Scope -NotePropertyValue $Scope
         $obj | Add-Member -NotePropertyName Separator -NotePropertyValue $Separator

         $obj | Add-Member -NotePropertyName Value -NotePropertyValue $Item

     $items = [System.Collections.ArrayList]@()
        $obj | Add-Member -NotePropertyName Items -NotePropertyValue $items 
 
        return $obj
    }
}
