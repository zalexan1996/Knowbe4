<#
.SYNOPSIS
    Handles token authentication to Knowbe4. 
.DESCRIPTION
    To authenticate with Knowbe4, do the following:
    1. Copy your API token from Knowbe4
    2. Run Save-Kb4Token, passing in your API token and a location to store it.
    3. Run Connect-Kb4 and specify the location Save-Kb4Token put your API token
.OUTPUTS
    Outputs a [KB4Connection] object that contains the URL, token, and auth headers.
#>
Function Connect-Kb4
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)][ValidateSet("Temp", "AppData", "UserRoot")][String]$TokenLocation
    )

    $TokenData = Import-Kb4Token -Location $TokenLocation
    $Script:KB4Connection = [KB4Connection]::new($TokenData.Token, $TokenData.HostURL)
    $Script:KB4Connection | Write-Output
}