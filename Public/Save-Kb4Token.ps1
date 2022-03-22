Function Save-Kb4Token
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)][String]$Token,
        [Parameter(Mandatory=$true)][ValidateSet("https://us.api.knowbe4.com", "https://eu.api.knowbe4.com")][String]$HostURL,
        [Parameter(Mandatory=$true)][ValidateSet("Temp", "AppData", "UserRoot")][String]$Location
    )
    
    $Locations = @{
        "Temp" = "$ENV:HOMEDRIVE\temp"
        "AppData" = "$ENV:APPDATA\KB4"
        "UserRoot" = "$ENV:USERPROFILE"
    }
    

    # Create the directory to store the token if it doesn't exist.
    if (!(Test-Path $Locations[$Location]))
    {
        $Parent = Split-Path $Locations[$Location]
        $Leaf = Split-Path $Locations[$Location] -Leaf
        New-Item -Path $Parent -Name $Leaf -ItemType Directory -Force
    }


    # Export the provided token and host to the json file
    [PSCustomObject]@{ "Token" = $Token; "HostURL" = $HostURL } | ConvertTo-Json | Out-File -FilePath "$($Locations[$Location])\.kb4token.json"
}