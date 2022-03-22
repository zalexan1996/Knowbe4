<#
.SYNOPSIS
Runs a Chrome webdriver and logs the browser into your Kb4 account. You can optionally pass in an existing web driver and it will go through the login process for Knowbe4's website.

.DESCRIPTION
Steps:
1. Downloads the required webdriver for your installed Chrome version (if it exists)
2. Starts the chrome webdriver and opens the KB4 login page.
3. This is where you login to KB4 on the opened Chrome driver. TODO: Automate this
4. The browser then navigates to the main login page. 
5. Returns the web driver even if the sign-in failed. It's up to the caller to verify that the driver is signed in. If all is good, navigating to training.knowbe4.com/ui/dashboard will not redirect to the sign-in page.

.PARAMETER Driver
Optionally pass in an existing web driver. Use this if you use custom logic to manage your drivers or don't use Chrome.

.OUTPUTS
A webdriver that has logged into the KB4 dashboard
#>
Function Start-Kb4Driver
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][Object]$Driver,
        [Parameter(Mandatory=$True)][PSCredential]$Credential,
        [Parameter(Mandatory=$False)][bool]$Visible = $TRUE
    )
    
    $Hints = @{
        Url = "https://training.knowbe4.com/"
        Kb4EmailTextBox = "//input[@qa-id='email']"
        Kb4NextButton = "//button[@qa-id='submit']"
        M365EmailTextBox = "//input[@type='email']"
        M365NextButton = "//input[@type='submit']"
        M365PasswordTextBox = "//input[@type='password']"
    }

    try {

        # If the user didn't supply a web driver, download the required chrome webdriver and use that.
        if ($NULL -eq $Driver) {
            $Driver = Start-Chrome -StartUrl $Hints.Url -Visible $Visible -ErrorAction Stop
        }
        else {
            TryNavigate $Driver $Hints.Url
        }



        # Type in the username and press next.
        (TryGetElement $Driver $Hints.Kb4EmailTextBox).SendKeys($Credential.Username)
        (TryGetElement $Driver $Hints.Kb4NextButton).Click()


        # TODO: Support for non-SSO accounts
        ## M365 Login Page
        ################################################################################
        ################################################################################
        ################################################################################

        # Type in the username
        (TryGetElement $Driver $Hints.M365EmailTextBox).SendKeys($Credential.Username)
        
        # Click Next
        (TryGetElement $Driver $Hints.M365NextButton).Click()
        

        # Wait for animations to finish
        Start-Sleep -Seconds 1

        # Send the password
        (TryGetElement $Driver $Hints.M365PasswordTextBox).SendKeys($Credential.GetNetworkCredential().Password)

        # Click Sign In
        (TryGetElement $Driver $Hints.M365NextButton).Click()
        
        # Wait for animations to finish
        Start-Sleep -Seconds 1

        # Click Yes on Stay Signed In?
        (TryGetElement $Driver $Hints.M365NextButton).Click()
        
        
        # Wait until the document has finished loading
        while ($Driver.ExecuteScript("return document.readyState") -notlike "complete")
        {
            Start-Sleep -Seconds 1
        }
        
        if ($Driver.Url -like "https://training.knowbe4.com/ui/dashboard")
        {
            $Driver | Write-Output
        }
        else
        {
            throw "Failed to authenticate with Knowbe4"
        }
    }
    catch {
        Write-Host "Failed to start Chrome driver"
        if ($Driver)
        {
            $Driver.Quit()
        }
        throw $_
    }
}