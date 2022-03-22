Function Import-Kb4Token
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)][ValidateSet("Temp", "AppData", "UserRoot")][String]$Location
    )
    $FileName = ".kb4token.json"
    $Locations = @{
        "Temp" = "$ENV:HOMEDRIVE\temp\$FileName"
        "AppData" = "$ENV:APPDATA\KB4\$FileName"
        "UserRoot" = "$ENV:USERPROFILE\$FileName"
    }

    # Output the Kb4 token from the path provided
    if (Test-Path $Locations[$Location])
    {
        Get-Content -Path $Locations[$Location] | ConvertFrom-Json | Write-Output
    }
    else
    {
        throw "No KB4 token exists at: '$($Locations[$Location])'"
    }
}