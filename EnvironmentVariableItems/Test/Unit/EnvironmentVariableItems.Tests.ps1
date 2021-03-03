<#
param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

# Remove trailing slash or backslash
$ModulePath = $ModulePath -replace '[\\/]*$'
$ModuleName = (Get-Item "$ModulePath\..").Name
$ModuleManifestName = 'EnvironmentVariableItems.psd1'
$ModuleManifestPath = Join-Path -Path $ModulePath -ChildPath $ModuleManifestName
#>

param (
    [Parameter(Mandatory)]
    [string] $File
)


BeforeAll {


    Get-Content $File | Foreach-Object{
        $var = $_.Split('=')
        New-Variable  -Name $var[0] -Value $var[1]
     }
     #write-host "`$ModulePath = $ModulePath"


    #$ModulePath = "$PSScriptRoot\..\..\Source\"
    #$ModulePath = 
"H:\proj\dev\20210226_pow_mod_EnvironmentVariableItems\EnvironmentVariableItems\bin\EnvironmentVariableItems\2.1.0"
    #$ModulePath = "$PSScriptRoot\..\..\bin\EnvironmentVariableItems\2.1.0\"


    # Remove trailing slash or backslash
    $ModulePath = $ModulePath -replace '[\\/]*$'
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifestName = 'EnvironmentVariableItems.psd1'
    $ModuleManifestPath = Join-Path -Path $ModulePath -ChildPath $ModuleManifestName

    #$foo = 'bark'
}



#Import-Module "$ModulePath\$ModuleName.psd1" -ErrorAction Stop



Describe 'Core Module Tests' -Tags 'CoreModule', 'Unit' {

    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should -Be $true
    }

    It 'Loads from module path without errors' {
        {Import-Module "$ModulePath\$ModuleName.psd1" -ErrorAction Stop} | Should -Not -Throw
    }

    AfterAll {
        Get-Module -Name $ModuleName | Remove-Module -Force
    }

}


Describe 'EnvironmentVariableItem Function Tests' -Tag 'Unit' {
    BeforeAll {
        Import-Module "$ModulePath\$ModuleName.psd1"
        $foo = 'bar'
    }

    AfterAll {
        Get-Module -Name $ModuleName | Remove-Module -Force
    }

    <#
    # Private functions tests in module scope
    InModuleScope $ModuleName {
        Context 'foo' {
            It 'Is true' {
                $True | Should -BeTrue
            }

            It 'Is false ' {
                $False | Should -BeFalse
            }


            It 'foo should be bar' {
                $foo -eq 'bar' | Should -BeTrue
            }

        }
    
        Context 'bar' {
            It 'Is true' {
                $True | Should -BeTrue
            }
            It 'Is false ' {
                $False | Should -BeFalse
            }
        }
    }
    #>

    # Public function tests
    Context 'cup' {
        It 'Is true' {
            $True | Should -BeTrue
        }
        It 'Is false ' {
            $False | Should -BeFalse
        }
    }

    Context 'cake' {
        It 'Is true' {
            $True | Should -BeTrue
        }
        It 'Is false ' {
            $False | Should -BeFalse
        }
    }
}
