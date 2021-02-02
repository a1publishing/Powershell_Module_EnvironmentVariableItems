@{

    RootModule        = 'EnvVar.psm1'

    ModuleVersion     = '0.1.0'

    GUID              = '48004ebf-fec1-48ae-9430-aba9ffead502'

    Author            = 'GNQG'

    Copyright         = '(c) 2019 @GNQG.'

    Description       = 'Handles environment variables, supporting variable expansion'

    PowerShellVersion = '3.0'

    FunctionsToExport = @("Get-EnvironmentVariable", "Set-EnvironmentVariable")

    CmdletsToExport   = @()

    VariablesToExport = @()

    AliasesToExport   = @()

    # FileList = @()

    PrivateData       = @{

        PSData = @{

            Tags       = @("environment", "envvar", "env", "path", "windows", "registry")

            LicenseUri = 'https://github.com/GNQG/pwsh-EnvVar/blob/master/LICENSE'

            ProjectUri = 'https://github.com/GNQG/pwsh-EnvVar'

            # ReleaseNotes = ''

        }
    }

    # HelpInfoURI = ''

}
