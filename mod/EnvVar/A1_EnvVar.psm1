$Win32 = Add-Type -Namespace "EnvVar.Import" -Name "Win32" -PassThru -MemberDefinition @"
            [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
            public static extern IntPtr SendMessageTimeout(
                IntPtr hWnd,
                uint Msg,
                UIntPtr wParam,
                string lParam,
                uint fuFlags,
                uint uTimeout,
                out UIntPtr lpdwResult
            );

            [DllImport("kernel32.dll")]
            public static extern uint GetLastError();
"@

function Get-EnvPath {
    param (
        [Parameter(Mandatory)]
        [System.EnvironmentVariableTarget]
        $Scope
    )
    switch ($Scope) {
        "Process" {
            return "Env:"
        }
        "User" {
            return "HKCU:\Environment"
        }
        "Machine" {
            return "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
        }
        Default {
            return
        }
    }
}

function New-EnvVar-Object {
    param (
        [Parameter(Mandatory)]
        [ValidatePattern("[^=]+")]
        $Name,
        [Parameter()]
        [AllowNull()]
        [String]
        $Value,
        [Parameter(Mandatory)]
        [System.EnvironmentVariableTarget]
        $Scope,
        [Parameter()]
        [AllowNull()]
        [ValidateSet("String", "ExpandString", $null)]
        [String]
        $ValueType,
        [Parameter()]
        [AllowNull()]
        [String]
        $BeforeExpansion
    )

    begin {
    }

    process {
        $obj = [PSCustomObject]@{
            Name            = $Name
            Value           = $Value
            Scope           = $Scope
            ValueType       = $ValueType
            BeforeExpansion = $BeforeExpansion
        }
        $obj | Add-Member ScriptMethod ToString { $this.Value } -Force
        return $obj
    }

    end {
    }
}

function Update-EnvVarSetting {
    param (
    )

    begin {
    }

    process {
        $HWND_BROADCAST = [IntPtr] 0xffff
        $WM_SETTINGCHANGE = 0x1a
        $result = [UIntPtr]::Zero

        $ret = $Win32::SendMessageTimeout(
            $HWND_BROADCAST,
            $WM_SETTINGCHANGE,
            [UIntPtr]::Zero,
            "Environment",
            2,
            5000,
            [ref] $result
        )
        if ($ret -eq 0) {
            $errorcode = $Win32::GetLastError($ret)
            Write-Error "failed to update environment setting (error code: $errorcode)"
        }
    }

    end {
    }
}

<#
    .SYNOPSIS
        Gets the environment variable for given name and scope.

    .EXAMPLE
        Get-EnvironmentVariable -Name SOME_ENVVAR -Scope Process
#>
function Get-EnvironmentVariable {
    [CmdletBinding()]
    param (
        # Name of the environment variable
        [Parameter(Position = 0, Mandatory)]
        [ValidatePattern("[^=]+")]
        [String]
        $Name,
        # Scope of the environment variable
        [Parameter()]
        [System.EnvironmentVariableTarget]
        $Scope = [System.EnvironmentVariableTarget]::Process
    )

    begin {
    }

    process {
        $value = [System.Environment]::GetEnvironmentVariable($Name, $Scope)
        if ($null -eq $value) {
            $rawvalue = $null
            $valuetype = $null
        } else {
            if ($Scope -ne "Process") {
                $allenv = Get-Item -Path (Get-EnvPath -Scope $Scope)
                $valuetype = $allenv.GetValueKind($Name)

                if ($valuetype -eq "ExpandString") {
                    $rawvalue = $allenv.GetValue(
                        $Name, $null, 'DoNotExpandEnvironmentNames'
                    )
                } elseif ($valuetype -eq "String") {
                    # $value -eq $rawvalue
                    $rawvalue = $null
                } else {
                    # inappropriate kind (dword, bytes, ...)
                    $rawvalue = $null
                    $valuetype = $null
                }
            } else {
                # $Scope -eq "Process"
                $rawvalue = $null
                $valuetype = "String"
            }
        }
        $params = @{
            Name            = $Name
            Value           = $value
            Scope           = $Scope
            ValueType       = $valuetype
            BeforeExpansion = $rawvalue
        }
        New-EnvVar-Object @params
    }

    end {
    }
}

<#
    .SYNOPSIS
        Sets the environment variable for given name and scope.

    .EXAMPLE
        Set-EnvironmentVariable -Name NEW_ENVVAR -Value new_value -Scope User -ValueType String -Inherit Auto
#>
function Set-EnvironmentVariable {
    [CmdletBinding()]
    param (
        # Name of the environment variable
        [Parameter(Position = 0, Mandatory)]
        [ValidatePattern("[^=]+")]
        [String]
        $Name,
        # Value of the environment variable
        [Parameter(Position = 1, Mandatory)]
        [String]
        $Value,
        # Scope of the environment variable
        [Parameter()]
        [System.EnvironmentVariableTarget]
        $Scope = [System.EnvironmentVariableTarget]::Process,
        # Type of the environment variable
        [Parameter()]
        [ValidateSet("String", "ExpandString")]
        [String]
        $ValueType = "String",
        # Inheritance method for the environment variable
        [Parameter()]
        [ValidateSet("Always", "Auto", "Never")]
        [String]
        $Inherit = "Auto"
    )

    begin {
    }

    process {
        # inheritance condition
        if ($Scope -eq "Process") {
            $inheritance = $false
        } else {
            switch ($Inherit) {
                "Never" {
                    $inheritance = $false
                }
                "Always" {
                    $inheritance = $true
                }
                "Auto" {
                    $cur_val_proc = [System.Environment]::GetEnvironmentVariable($Name)
                    if ($Name -eq "Path") {
                        $cur_val_m = [System.Environment]::GetEnvironmentVariable($Name, "Machine")
                        $cur_val_u = [System.Environment]::GetEnvironmentVariable($Name, "User")
                        $cur_val = $cur_val_m + $cur_val_u
                    } else {
                        $cur_val = [System.Environment]::GetEnvironmentVariable($Name, $Scope)
                    }

                    if ($cur_val -eq $cur_val_proc) {
                        $inheritance = $true
                    } else {
                        $inheritance = $false
                    }
                }
                Default { }
            }
        }

        # set value
        if (($ValueType -eq "String") -or ($Scope -eq "Process")) {
            if ($ValueType -eq "ExpandString") {
                # $Scope -eq "Process"
                $val = [System.Environment]::ExpandEnvironmentVariables($Value)
            } else {
                $val = $Value
            }
            [System.Environment]::SetEnvironmentVariable($Name, $val, $Scope)
        } else {
            Set-ItemProperty -Path (Get-EnvPath $Scope) -Name $Name -Value $Value -Type $ValueType
            Update-EnvVarSetting
        }

        # inherit
        if ($inheritance) {
            if ($Name -eq "Path") {
                $cur_val_m = [System.Environment]::GetEnvironmentVariable($Name, "Machine")
                $cur_val_u = [System.Environment]::GetEnvironmentVariable($Name, "User")
                $cur_val = $cur_val_m + $cur_val_u
            } else {
                $cur_val = [System.Environment]::GetEnvironmentVariable($Name, $Scope)
            }

            [System.Environment]::SetEnvironmentVariable($Name, $cur_val, "Process")
        }

        Get-EnvironmentVariable -Name $Name -Scope $Scope
    }

    end {
    }
}

Export-ModuleMember -Function Get-EnvironmentVariable, Set-EnvironmentVariable
