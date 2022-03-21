
Function New-Kb4User
{
    [CmdletBinding()]
    Param(
        # The web driver
        [Parameter(Mandatory=$True)][Object]$Driver,

        # Mandatory Values for new creation
        [Parameter(Mandatory=$True)][String]$Email,
        [Parameter(Mandatory=$True)][String]$FirstName,
        [Parameter(Mandatory=$True)][String]$LastName,
        
        # Extended properties sent to Set-Kb4User
        [Parameter(Mandatory=$False)][ValidateSet("Low", "Normal", "High", "Highest")][String]$RiskBooster,
        [Parameter(Mandatory=$False)][String]$PhoneNumber,
        [Parameter(Mandatory=$False)][String]$Extension,
        [Parameter(Mandatory=$False)][String]$MobilePhoneNumber,
        [Parameter(Mandatory=$False)][String]$Location,
        [Parameter(Mandatory=$False)][String]$Division,
        [Parameter(Mandatory=$False)][String]$ManagerName,
        [Parameter(Mandatory=$False)][String]$ManagerEmail,
        [Parameter(Mandatory=$False)][String]$EmployeeNumber,
        [Parameter(Mandatory=$False)][String]$JobTitle,
        [Parameter(Mandatory=$False)][String]$Organization,
        [Parameter(Mandatory=$False)][String]$Department,
        [Parameter(Mandatory=$False)][String]$Comment,
        [Parameter(Mandatory=$False)][DateTime]$EmployeeStartDate,
        [Parameter(Mandatory=$False)][String]$CustomField1,
        [Parameter(Mandatory=$False)][String]$CustomField2,
        [Parameter(Mandatory=$False)][String]$CustomField3,
        [Parameter(Mandatory=$False)][String]$CustomField4,
        [Parameter(Mandatory=$False)][DateTime]$CustomDate1,
        [Parameter(Mandatory=$False)][DateTime]$CustomDate2
    )

    # Edit these if the website changes their design.
    $Hints = @{
        EmailInputId = "__BVID__103"
        firstNameInputId = "__BVID__105"
        lastNameInputId = "__BVID__107"
        createButtonClass = "btn-primary"
        createButtonText = "Create User"
        URL = "https://training.knowbe4.com/ui/users/users/new"
    }


    # Go to the create user page
    Enter-SeUrl -Driver $Driver -Url $Hints["URL"]

    # Search for the inputs
    $emailInput = $Driver.FindElementById($Hints["EmailInputId"])
    $firstNameInput = $Driver.FindElementById($Hints["firstNameInputId"])
    $lastNameInput = $Driver.FindElementById($Hints["lastNameInputId"])
    $createButton = $Driver.FindElementByClassName($Hints["createButtonClass"]) | Where-Object Text -like $Hints["createButtonText"]

    # Make sure the inputs are valid.
    if ($NULL -eq $emailInput) { throw "Failed to find Email input with id:'$($Hints["EmailInputId"])'"}
    if ($NULL -eq $firstNameInput) { throw "Failed to find First Name input with id:'$($Hints["firstNameInputId"])'"}
    if ($NULL -eq $lastNameInput) { throw "Failed to find Last Name input with id:'$($Hints["lastNameInputId"])'"}
    if ($NULL -eq $createButton) { throw "Failed to find Create User button with class:'$($Hints["createButtonClass"])' and Text:'$($Hints["createButtonText"])'"}

    # Send the data
    $emailInput.SendKeys($Email)
    $firstNameInput.SendKeys($FirstName)
    $lastNameInput.SendKeys($LastName)
    $createButton.Click()

    Start-Sleep -Milliseconds 2000

    # Navigate to the new user's page to get the user id
    Enter-SeUrl -Url "https://training.knowbe4.com/ui/users/?search=$Email" -Driver $Driver

    # Wait for the table to finish loading
    while ($driver.executeScript("return document.readyState") -notlike "complete" -or $Driver.FindElementsByTagName("table").GetAttribute("aria-busy") -like "true")
    {
        Start-Sleep -Milliseconds 250
    }

    # Get the full URL to the new users page
    $NewUserLink = $Driver.FindElementsByTagName("a") | Where-Object { $_.GetAttribute("href") -like "https://training.knowbe4.com/ui/users/*/details" }
    
    # Make sure we got a link to the new users's page
    if ($NULL -eq $NewUserLink)
    {
        throw "Failed to find user page for newly created user: $Email"  
    }

    # Extract the user id from the href
    $user_id = (Select-String -Pattern "(?<=/)\d+" -InputObject $NewUserLink.GetAttribute("href") -AllMatches).Matches.Value

    # Make sure the user id is valid.
    if ([String]::IsNullOrEmpty($user_id))
    {
        throw "Failed to extract user id for newly created user: $Email"   
    }

    # Since Set-Kb4User uses the same parameters that New-Kb4Users uses, we can just splat the hashtable of used parameters
    Set-Kb4User -id $user_id @PSBoundParameters
}

# SIG # Begin signature block
# MIIIXQYJKoZIhvcNAQcCoIIITjCCCEoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUBJ0cwC6zKFyzywdZ3fj4AdgI
# Xr6gggW7MIIFtzCCBJ+gAwIBAgITIAAAAtaXwewHS8gOOgAAAAAC1jANBgkqhkiG
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQ4mbvr1vkQTK/98G4xr197EPQ4VDAN
# BgkqhkiG9w0BAQEFAASCAQAKh8UVK9VhBR+i84UBFAD1fGx9tT7siPY3xIXcBK+e
# eB09i/2JWg9WhxMiU0r0otkSwJZsVLUuDtumAVD468wA44He2eol1adAtXpY2sBT
# 2Hnyj7dvMPW+XiuSfKra0YJMyijj8d17NEpgxqUd/3Iu77x6N6fOQGq418S2jH1e
# kqBYSLEhV2DpyevVtOVS4AWyQnyrWZ29FDjEL6O/qQJ9rLPb05ZHIUiFh574ETv+
# VOg4D/asTEVM0A0lWzmKLL3Cx5e742fkavvpv7MV/RimghEcI6RbiUSg4sUzl+Kv
# Qetva2x2GYrwri5SzE1+s+qW07iZr6hs245P+4ZFoykw
# SIG # End signature block
