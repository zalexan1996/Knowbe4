# Knowbe4
Simplifies PowerShell access to the KMSAT reporting API as well as to user management via the Selenium web driver. 

There are two parts to this module. The first part consists of commands that access the KMSAT RestAPI. The second part consists of commands that control a WebDriver to handle things that the RestAPI can't handle:
- managing users
- TODO: managing groups
- TODO: managing campaigns
- TODO: creating email templates

If you want to communicate with the RestAPI, you'll need to call `Connect-Kb4`. If you only want to use the web driver commands, you don't need to call `Connect-Kb4`, but you will need to call `Start-Kb4Driver`.

# Examples
## Authenticating with Knowbe4 
Before running any commands, you need to generate an API token in the Account Settings page in Knowbe4. Then, run the following command.

    # This command will need to be ran the very first time. It stores your API token in a location of your choosing
    Save-Kb4Token -Token "TOKEN" -Location AppData HostURL "https://us.api.knowbe4.com"

    # This command will need to be ran after calling Save-Kb4Token and before you run the other KB4 commands.
    Connect-Kb4 -TokenLocation AppData

## Starting the Webdriver
    # Opens a driver. By default, it will use Chrome and try to get the correct webdriver version from Chromium. 
    # If you want to use another browser or use custom logic for creating the web driver, use the -Driver parameter to pass in a driver of your choosing.
    Start-Kb4Driver

    # Start-Kb4Driver will navigate to the login page where you'll need to manually login. Once it's logged in, go back to the PowerShell console and press Enter to continue on.

## Migrating AzureAD environment to Knowbe4
    # Start the web driver
    $Driver = Start-Kb4Driver

    # Make sure the driver isn't null
    if ($NULL -eq $Driver)
    {
        throw "Failed to login to Knowbe4"
    }

    # Connect to the RestAPI using a token stored in AppData
    Connect-Kb4 -TokenLocation AppData

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


# TODO
- Automate the web driver login page with PSCredential
- Add web driver functions for creating groups and campaigns
- Add help files
- Add UserEvent and PhishER functions