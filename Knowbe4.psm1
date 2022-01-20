# Import the internal helper functions first
. "$PSScriptRoot\Private\_Ensure-Connected.ps1"
. "$PSScriptRoot\Private\_Invoke-RestWithPagination.ps1"
. "$PSScriptRoot\Private\_KB4Connection.ps1"

# Import all KB4 cmdlets
    # Authentication
    . "$PSScriptRoot\Public\Import-Kb4Token.ps1"
    . "$PSScriptRoot\Public\Save-Kb4Token.ps1"
    . "$PSScriptRoot\Public\Connect-Kb4.ps1"

    # Users
    . "$PSScriptRoot\Public\Get-KB4Users.ps1"
    . "$PSScriptRoot\Public\Get-KB4UserRiskSummary.ps1"

    # Groups
    . "$PSScriptRoot\Public\Get-KB4Groups.ps1"

    # Web drivers
    . "$PSScriptRoot\Public\Start-Kb4Driver.ps1"
    . "$PSScriptRoot\Public\New-Kb4User.ps1"
    . "$PSScriptRoot\Public\Set-Kb4User.ps1"
    . "$PSScriptRoot\Public\Remove-Kb4User.ps1"
    