@{
    Path = "EnvironmentVariableItems.psd1"
    OutputDirectory = "..\bin\EnvironmentVariableItems"
    Prefix = '.\_PrefixCode.ps1'
    SourceDirectories = 'Classes','Private','Public'
    PublicFilter = 'Public\*.ps1'
    VersionedOutputDirectory = $true
}
