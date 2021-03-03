# EnvironmentVariableItems Build Notes

## Build (beta/work in progress)

### Invoke-Build additional parameter
    - PesterOutput
        - passed to Invoke-Pester Output parameter in build script, eg., Invoke-Pester -Output $PesterOutput
PS> 
Invoke-Build TestCode -File .\EnvironmentVariableItems.build.ps1 -PesterOutput Detailed 

### Testing, eg.;
PS> 
Invoke-Build TestCode -File .\EnvironmentVariableItems.build.ps1

### Build, eg.;
PS> Invoke-Build -File .\EnvironmentVariableItems.build.ps1


## NOTES/TODO: 
    - original code/guide sources
        - https://www.pipehow.tech/new-plastermodule/
        - https://github.com/PowerShellOrg/Plaster
        - https://github.com/SimonWahlin/gyPSum
    - updated to use Pester 5 (from 4)
    - code coverage in TestBuild task not working for Pester 5 so commented out
#>
