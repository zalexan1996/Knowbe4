# Connect to the RestAPI using a token stored in AppData
Connect-Kb4 -TokenLocation AppData

# Start the web driver
$Driver = Start-Kb4Driver

# Import AzureAD (AzureAD doesn't have a PowerShell 7 version.)
Import-Module AzureAD -UseWindowsPowerShell

# Connect to AzureAD
Connect-AzureAD

# Get a list of all users currently in KB4
$Kb4Users = Get-KB4Users

# Get all licensed AzureAD users that aren't in KB4 yet and create accounts for them.
Get-AzureADUser -All:$True | Where-Object {$_.AssignedLicenses -and $_.UserPrincipalName -notin $Kb4Users.email} | Foreach-Object {

    # Get the manager object
    $Manager = $_ | Get-AzureADUserManager

    # Create a user in Knowbe4
    New-Kb4User -Driver $Driver -Email $_.UserPrincipalName -FirstName $_.GivenName -LastName $_.SurName `
        -Department $_.Department -ManagerName $Manager.DisplayName -ManagerEmail $Manager.UserPrincipalName # etc.
}