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
        [Parameter(Mandatory=$False)][Object]$Driver,
        [Parameter(Mandatory=$True)][PSCredential]$Credential,
        [Parameter(Mandatory=$False)][bool]$Visible = $TRUE
    )
    
    try {
        # If the user didn't supply a web driver, download the required chrome webdriver and use that.
        if ($NULL -eq $Driver)
        {
            # Go to Knowbe4
            $Driver = Start-Chrome -StartUrl "https://training.knowbe4.com/" -Visible $Visible -ErrorAction Stop
        }
        else 
        {
            Enter-SeUrl -Driver $Driver -Url "https://training.knowbe4.com/" -ErrorAction Stop
        }



        # Type in the username
        $EmailTextBox = $Driver.FindElementById("email")
        if ($NULL -eq $EmailTextBox)
        {
            throw "Failed to find the Email text box with id:email"
        }
        $EmailTextBox.SendKeys($Credential.Username)

        # Press Next to go to M365 authentication
        $NextButton = $Driver.FindElementsByTagName("button") | Where-Object { $_.Text -like "Next" }
        if ($NULL -eq $NextButton)
        {
            throw "Failed to find the Next button with tag:button and text:Next"
        }
        $NextButton.Click()


        ## M365 Login Page
        ################################################################################
        ################################################################################
        ################################################################################

        # Type in the username
        $M365EmailTextBox = $Driver.FindElementsByName("loginfmt")
        if ($NULL -eq $M365EmailTextBox)
        {
            throw "Failed to find the M365 Email text box with name:loginfmt"
        }
        $M365EmailTextBox.SendKeys($Credential.Username)
        
        # Click Next
        $M365NextButton = $Driver.FindElementsByClassName("button_primary")
        if ($NULL -eq $M365NextButton)
        {
            throw "Failed to find the M365 Next button with class:button_primary"
        }
        $M365NextButton.Click()
        
        # Wait for their animation to finish
        Start-Sleep -Seconds 1

        # Send the password
        $M365PasswordTextBox = $Driver.FindElementsByName("passwd")
        if ($NULL -eq $M365PasswordTextBox)
        {
            throw "Failed to find the M365 Password text box with name:passwd"
        }
        $M365PasswordTextBox.SendKeys($Credential.GetNetworkCredential().Password)

        # Click Sign In
        $M365SignInButton = $Driver.FindElementsByClassName("button_primary")
        if ($NULL -eq $M365SignInButton)
        {
            throw "Failed to find the M365 Sign-In button with class:button_primary"
        }
        $M365SignInButton.Click()
        
        Start-Sleep -Seconds 1

        # Click Yes on Stay Signed In?
        $M365StaySignedInButton = $Driver.FindElementsByClassName("button_primary")
        if ($NULL -eq $M365StaySignedInButton)
        {
            throw "Failed to find the M365 Stay signed-in button with class:button_primary"
        }
        $M365StaySignedInButton.Click()
        
        
        # Wait until the document has finished loading
        while ($Driver.ExecuteScript("return document.readyState") -notlike "complete")
        {
            Start-Sleep -Seconds 1
        }
        
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
# SIG # Begin signature block
# MIIIXQYJKoZIhvcNAQcCoIIITjCCCEoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfYIuWG1tKgJmxKlb/dAqYX9d
# X1qgggW7MIIFtzCCBJ+gAwIBAgITIAAAAtaXwewHS8gOOgAAAAAC1jANBgkqhkiG
# 9w0BAQwFADBUMRMwEQYKCZImiZPyLGQBGRYDbmV0MRowGAYKCZImiZPyLGQBGRYK
# c2ZnbmV0d29yazEhMB8GA1UEAxMYc2ZnbmV0d29yay1TRkdORVRXT1JLLUNBMB4X
# DTIyMDEyNzE2NDUwNloXDTIzMDEyNzE2NDUwNlowWjETMBEGCgmSJomT8ixkARkW
# A25ldDEaMBgGCgmSJomT8ixkARkWCnNmZ25ldHdvcmsxDjAMBgNVBAsTBTUxLUlU
# MRcwFQYDVQQDEw5aYWNoIEFsZXhhbmRlcjCCASIwDQYJKoZIhvcNAQEBBQADggEP
# ADCCAQoCggEBAOz2G9QI8tH2sBLTPjy9ggA8H0gWIYEwhItffWhC//YjInZvoQSX
# 0OROfXQPzsKIrGm8Ry+ULYwQLVNTY1JM4Gw8Q9apUj2Lj7gFS0fJ+cuLIreUs6GK
# WX+t0eB0md30e7ocGmxb50CVdyrs+/3mCqHXdqnYFybuJpqLR3msQi/j739fRs80
# ti1qzRAvdt6OpjfSYbhOL8BMeeKGyjxPMGVhUHambQjPjH/iimZYfan3qtKBOIww
# HpV/oCjMwnuMkB5DOn7/mejs1+/P82gXjlJZZWFFM/+dYpuE2q9OtHhpM1FzRVMp
# /cEku1iV4wK/zd8FdxmfbOULvaLe40/FyxUCAwEAAaOCAnowggJ2MCUGCSsGAQQB
# gjcUAgQYHhYAQwBvAGQAZQBTAGkAZwBuAGkAbgBnMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMA4GA1UdDwEB/wQEAwIHgDAdBgNVHQ4EFgQU8dgE5AlWVG3M3fG54E9xetYb
# CCMwHwYDVR0jBBgwFoAUfpD6YhkIAsVEQoUE0d128tYMrREwgd0GA1UdHwSB1TCB
# 0jCBz6CBzKCByYaBxmxkYXA6Ly8vQ049c2ZnbmV0d29yay1TRkdORVRXT1JLLUNB
# LENOPVNGRy1TUlYtQ0FTLENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNl
# cyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXNmZ25ldHdvcmssREM9
# bmV0P2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RDbGFzcz1j
# UkxEaXN0cmlidXRpb25Qb2ludDCBzQYIKwYBBQUHAQEEgcAwgb0wgboGCCsGAQUF
# BzAChoGtbGRhcDovLy9DTj1zZmduZXR3b3JrLVNGR05FVFdPUkstQ0EsQ049QUlB
# LENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZp
# Z3VyYXRpb24sREM9c2ZnbmV0d29yayxEQz1uZXQ/Y0FDZXJ0aWZpY2F0ZT9iYXNl
# P29iamVjdENsYXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwOAYDVR0RBDEwL6At
# BgorBgEEAYI3FAIDoB8MHVphY2hfQWxleGFuZGVyQHNmZ25ldHdvcmsuY29tMA0G
# CSqGSIb3DQEBDAUAA4IBAQBAd4ZQ5xJcaI8s9nXTrCLAr/p3yPbNjvduBmhAdmHR
# gs+VTN9QEHDcMK49WNsTZ4QYQ3brZk+/lQgxZ3habIX9P6k+JrSV1vY0V3xOy+6I
# t4ybmq+vgvdC1qB9+ADt5Dm8fQYwrCz72RaJGjli9Lt6siPRo7Y7Bu2bNezwFBQg
# 497Sh0NtXYG5vQdyXQEbu/XCjE++5wqs0zp3S99N4u2cYw3bNHb7gw+XJoozVDgG
# U3vB6uqqX4LKZDpZGlZKXOa6ONIjValac+R373omIls5DlKqrI6ORqkn955WYXB2
# nPMJk3Hx3hWiNY1ljyIgOzG+VNGdUNYUO7yjPP5B44ltMYICDDCCAggCAQEwazBU
# MRMwEQYKCZImiZPyLGQBGRYDbmV0MRowGAYKCZImiZPyLGQBGRYKc2ZnbmV0d29y
# azEhMB8GA1UEAxMYc2ZnbmV0d29yay1TRkdORVRXT1JLLUNBAhMgAAAC1pfB7AdL
# yA46AAAAAALWMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAA
# MBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgor
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBT2VbPf98J5rJy6IgwUZ/baHzBUODAN
# BgkqhkiG9w0BAQEFAASCAQCkMovGMb9/HMyHF/JuYs/ENRfuX/9/H0mrOL4I+1jV
# iyDd2YNyekTfM9HwtVRH8PBcy2TFGmppI8axELczJryLrWMZY1lZf3OhG0ViZpHa
# 8/b2KmdFWMGnVbSSqZtoHbnrXJVB2ihT3HM3Rx3I8lmfAlKIvpkc/KBrd23OLHus
# iinVmmvL1OnQSw+XKzosAVQA8KMCeeJv62/fi8rTAUu6cu5HxY1WXHYwPvkySCq1
# miOASsUdTEAlmyBSUXIllf6vSdl+rpK2p6YDgCLSMt4dXMFhi2fJqUrU3xt4D1SE
# 9s5ckzRdKn8mbMsinzUqMQRq33vYj4hZp43HtaaE/Z+d
# SIG # End signature block
