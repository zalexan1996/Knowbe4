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
