Function Set-Kb4User
{
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$True)][Object]$Driver,

        [Parameter(Mandatory=$True, ValueFromPipeline, ValueFromPipelineByPropertyName)][int]$id,

        [Parameter(Mandatory=$False)][String]$Email,
        [Parameter(Mandatory=$False)][String]$FirstName,
        [Parameter(Mandatory=$False)][String]$LastName,
        [Parameter(Mandatory=$False)][ValidateSet("Low", "Normal", "High", "Highest")][String]$RiskBooster = "Normal",
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
    Function Update-Field
    {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory=$True, ValueFromPipeline)][Object]$Driver,
            [Parameter(Mandatory=$True, ParameterSetName="ByName")][String]$XPath,
            [Parameter(Mandatory=$True)][String]$NewValue
        )
        $Field = $Driver.FindElementByXPath($XPath)
        try { $Field.Clear() } catch {}     # Some fields don't need to be cleared so ignore any errors.
        $Field.SendKeys($NewValue)
    }
    
    $Hints = @{
        URL = "https://training.knowbe4.com/ui/users/$id/details"
        Email = "//input[@name='Email']"
        FirstName = "//input[@name='First Name']"
        LastName = "//input[@name='Last Name']"
        PhoneNumber = "//input[@name='Phone Number']"
        Extension = "//input[@name='Extension']"
        MobilePhoneNumber = "//input[@name='Mobile Phone Number']"
        Location = "//input[@name='Location']"
        Division = "//input[@name='Division']"
        ManagerName = "//input[@name='Manager Name']"
        ManagerEmail = "//input[@name='Manager Email']"
        EmployeeNumber = "//input[@name='Employee Number']"
        JobTitle = "//input[@name='Job Title']"
        Organization = "//input[@name='Organization']"
        Department = "//input[@name='Department']"
        Comment = "//textarea[@name='Comment']"
        CustomField1 = "//input[@name='Custom Field 1']"
        CustomField2 = "//input[@name='Custom Field 2']"
        CustomField3 = "//input[@name='Custom Field 3']"
        CustomField4 = "//input[@name='Custom Field 4']"
        CustomDate1 = "//span[@qa-id='Custom Date 1']//input[@class='form-control']"
        CustomDate2 = "//span[@qa-id='Custom Date 2']//input[@class='form-control']"

        RiskBooster = "//div[contains(@class, 'step-label') and text()='$RiskBooster']"
        EmployeeStartDate = "//div[@id='datePicker']//input[@class='form-control']"
        EmployeeStartTime = "//div[@id='timePicker']//input[@class='form-control']"

        SubmitButton = "//button[@qa-id='editUser']"
    }

    # Navigate to the user edit page
    if (!(TryNavigate -Driver $Driver -Url $Hints.Url)) {
        throw "Navigation to '$($Hints.Url)' failed.`nEnsure that the driver was properly authenticated."
    }



    # Update string fields
    if ($Email)             { $Driver | Update-Field -XPath $Hints.Email -NewValue $Email }
    if ($FirstName)         { $Driver | Update-Field -XPath $Hints.FirstName -NewValue $FirstName }
    if ($LastName)          { $Driver | Update-Field -XPath $Hints.LastName -NewValue $LastName }
    if ($PhoneNumber)       { $Driver | Update-Field -XPath $Hints.PhoneNumber -NewValue $PhoneNumber }
    if ($Extension)         { $Driver | Update-Field -XPath $Hints.Extension -NewValue $Extension }
    if ($MobilePhoneNumber) { $Driver | Update-Field -XPath $Hints.MobilePhoneNumber -NewValue $MobilePhoneNumber }
    if ($Location)          { $Driver | Update-Field -XPath $Hints.Location -NewValue $Location }
    if ($Division)          { $Driver | Update-Field -XPath $Hints.Division -NewValue $Division }
    if ($ManagerName)       { $Driver | Update-Field -XPath $Hints.ManagerName -NewValue $ManagerName }
    if ($ManagerEmail)      { $Driver | Update-Field -XPath $Hints.ManagerEmail -NewValue $ManagerEmail }
    if ($EmployeeNumber)    { $Driver | Update-Field -XPath $Hints.EmployeeNumber -NewValue $EmployeeNumber }
    if ($JobTitle)          { $Driver | Update-Field -XPath $Hints.JobTitle -NewValue $JobTitle }
    if ($Organization)      { $Driver | Update-Field -XPath $Hints.Organization -NewValue $Organization }
    if ($Department)        { $Driver | Update-Field -XPath $Hints.Department -NewValue $Department }
    if ($Comment)           { $Driver | Update-Field -XPath $Hints.Comment -NewValue $Comment }
    if ($CustomField1)      { $Driver | Update-Field -XPath $Hints.CustomField1 -NewValue $CustomField1 }
    if ($CustomField2)      { $Driver | Update-Field -XPath $Hints.CustomField2 -NewValue $CustomField2 }
    if ($CustomField3)      { $Driver | Update-Field -XPath $Hints.CustomField3 -NewValue $CustomField3 }
    if ($CustomField4)      { $Driver | Update-Field -XPath $Hints.CustomField4 -NewValue $CustomField4 }
    if ($CustomDate1)       { $Driver | Update-Field -XPath $Hints.CustomDate1 -NewValue $CustomDate1.ToString("MM/dd/yyyy") }
    if ($CustomDate2)       { $Driver | Update-Field -XPath $Hints.CustomDate2 -NewValue $CustomDate2.ToString("MM/dd/yyyy") }

    if ($EmployeeStartDate) { $Driver | Update-Field -XPath $Hints.EmployeeStartDate -NewValue $EmployeeStartDate.ToString("MM/dd/yyyy") }
    if ($EmployeeStartDate) { $Driver | Update-Field -XPath $Hints.EmployeeStartTime -NewValue $EmployeeStartDate.ToString("H/mm") }


    (TryGetElement $Driver $Hints.RiskBooster).Click()


    # Submit the data
    (TryGetElement $Driver $Hints.SubmitButton).Click()
}


# SIG # Begin signature block
# MIIIXQYJKoZIhvcNAQcCoIIITjCCCEoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnCQo8H/mKnAHIy4LNbZmnt+R
# +iagggW7MIIFtzCCBJ+gAwIBAgITIAAAAtaXwewHS8gOOgAAAAAC1jANBgkqhkiG
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQPiXdlSWa95fsdilsY2nded2AZezAN
# BgkqhkiG9w0BAQEFAASCAQB1seKY0ynpyZIajwJsZuPvk8lOt0PVyTvRp6aK+06h
# EKhg2V0iKfkoR01AoUefDHoqV7pQZ3kauvJKh5VCZY43224m2isTACh9RFVSm5pX
# QAQKpeIDJwxlNSWMTfSNQCewfoKK8tdg3dsT+uMlr2y2lRt5AKjV8sI3S7cV5TdC
# lvCSJ9JGBMhsqAWSHr0w0YHU3h/kLctR101zSmr3+7609nMs31BgCwJVQrcnjMC8
# sCgEjWHvXZfLG7+M6gomqW8vCQ4GMlX9eUkPt/Ya66R7FHPQg/jDijBmTPdxv6nE
# klzhito1kMFUOOQVzf+Df5/gsf8+Na5Z0sE4UqHjagiP
# SIG # End signature block
