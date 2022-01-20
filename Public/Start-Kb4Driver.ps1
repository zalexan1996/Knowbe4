<#
.SYNOPSIS
Runs a Chrome webdriver and logs the browser into your Kb4 account. You can optionally pass in an existing web driver and it will go through the login process for Knowbe4's website.

.DESCRIPTION
Steps:
1. Downloads the required webdriver for your installed Chrome version (if it exists)
2. Starts the chrome webdriver and opens the KB4 login page.
3. This is where you login to KB4 on the opened Chrome driver. TODO: Automate this
4. The browser then navigates to the main login page. 
5. If the page content indicates that you've logged in, it returns the web driver. Else NULL

.PARAMETER Driver
Optionally pass in an existing web driver. Use this if you use custom logic to manage your drivers or don't use Chrome.

.OUTPUTS
On success: A webdriver that has logged into the KB4 dashboard
On failure: NULL
#>
Function Start-Kb4Driver
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)][Object]$Driver
    )
    Function Start-Chrome
    {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory=$True)][String]$StartUrl 
        )
    
        # Get the current chrome version
        $ChromeVersion = Get-ChildItem "${ENV:ProgramFiles(x86)}\Google\Chrome\Application" | Where-Object { $_.Attributes -like "Directory" -and $_.Name -match "^\d+" } | Select-Object -First 1 -ExpandProperty Name
    
        # Get the web driver for my Chrome version
        Invoke-WebRequest -URI "https://chromedriver.storage.googleapis.com/$ChromeVersion/chromedriver_win32.zip" -OutFile $ENV:TEMP\chromedriver.zip
    
        # Extract the zip
        Expand-Archive $ENV:TEMP\chromedriver.zip -DestinationPath "$ENV:TEMP\chromedriver" -Force
    
        # Start chrome with the correct web driver.
        Start-SeChrome -WebDriverDirectory "$ENV:TEMP\chromedriver" -StartURL $StartUrl -Incognito -Quiet
    }
    
    try {
        # If the user didn't supply a web driver, download the required chrome webdriver and use that.
        if ($NULL -eq $Driver)
        {
            # Go to Knowbe4
            $Driver = Start-Chrome -StartUrl "https://training.knowbe4.com/" -ErrorAction Stop
        }
        else 
        {
            Enter-SeUrl -Driver $Driver -Url "https://training.knowbe4.com/" -ErrorAction Stop
        }
        
        
        # Login to Knowbe4
        Read-Host -Prompt "Please login to Knowbe4, then press enter" | Out-NULL

        
        # Reset the page to the main dashboard. This prevents stale state
        Enter-SeUrl -Driver $Driver -Url "https://training.knowbe4.com/ui/dashboard" | Out-NULL

        # Wait for the page to finish redirecting.
        Start-Sleep -Seconds 2
        
        # If our URL after redirection was the dashboard, then we are logged in. Otherwise, it'll redirect it to the login url.
        if ($Driver.URL -like "https://training.knowbe4.com/ui/dashboard")
        {
            # Output the chrome driver
            $Driver | Write-Output
        }
        else
        {
            $NULL | Write-Output
        }
    }
    catch {
        Write-Host "Failed to start Chrome driver"
        throw $_
    }
}