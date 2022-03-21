Function Set-Kb4User
{
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$True)][Object]$Driver,

        [Parameter(Mandatory=$True, ValueFromPipeline, ValueFromPipelineByPropertyName)][int]$id,

        [Parameter(Mandatory=$False)][String]$Email,
        [Parameter(Mandatory=$False)][String]$FirstName,
        [Parameter(Mandatory=$False)][String]$LastName,
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
        [Parameter(Mandatory=$False)][String]$CustomField4
    )
    Function Update-Field
    {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory=$True, ValueFromPipeline)][Object]$Driver,
            [Parameter(Mandatory=$True, ParameterSetName="ByName")][String]$FieldName,
            [Parameter(Mandatory=$True, ParameterSetName="ById")][String]$FieldId,
            [Parameter(Mandatory=$True)][String]$NewValue
        )
        if ($PSCmdlet.ParameterSetName -like "ByName")
        {
            $Field = $Driver.FindElementsByName("$FieldName")[0]
        }
        elseif ($PSCmdlet.ParameterSetName -like "ById")
        {
            $Field = $Driver.FindElementsById("$FieldId")[0]
        }

        if ($NULL -eq $Field)
        {
            throw "Failed to find field for $FieldName=$NewValue"
        }
        else {
            $Field.Clear()
            $Field.SendKeys($NewValue)
        }
    }

    # Navigate to the user edit page
    Enter-SeUrl -Driver $Driver -Url "https://training.knowbe4.com/ui/users/$id/details"


    # Find the submit button
    $sBtnClass = "btn-primary"
    $sBtnText = "Update User"
    $SubmitButton = $Driver.FindElementsByClassName("$sBtnClass") | Where-Object Text -like "$sBtnText" | Select-Object -First 1

    # If we couldn't find the submit button, terminate the function. They must have updated their site.
    if ($NULL -eq $SubmitButton)
    {
        throw "Failed to find submit button with class:'$sBtnClass' and text:'$sBtnText'"
    }


    # Update string fields
    if ($Email) { $Driver | Update-Field -FieldName "Email" -NewValue $Email }
    if ($FirstName) { $Driver | Update-Field -FieldName "First Name" -NewValue $FirstName }
    if ($LastName) { $Driver | Update-Field -FieldName "Last Name" -NewValue $LastName }
    if ($PhoneNumber) { $Driver | Update-Field -FieldName "Phone Number" -NewValue $PhoneNumber }
    if ($Extension) { $Driver | Update-Field -FieldName "Extension" -NewValue $Extension }
    if ($MobilePhoneNumber) { $Driver | Update-Field -FieldName "Mobile Phone Number" -NewValue $MobilePhoneNumber }
    if ($Location) { $Driver | Update-Field -FieldName "Location" -NewValue $Location }
    if ($Division) { $Driver | Update-Field -FieldName "Division" -NewValue $Division }
    if ($ManagerName) { $Driver | Update-Field -FieldName "Manager Name" -NewValue $ManagerName }
    if ($ManagerEmail) { $Driver | Update-Field -FieldName "Manager Email" -NewValue $ManagerEmail }
    if ($EmployeeNumber) { $Driver | Update-Field -FieldName "Employee Number" -NewValue $EmployeeNumber }
    if ($JobTitle) { $Driver | Update-Field -FieldName "Job Title" -NewValue $JobTitle }
    if ($Organization) { $Driver | Update-Field -FieldName "Organization" -NewValue $Organization }
    if ($Department) { $Driver | Update-Field -FieldName "Department" -NewValue $Department }
    if ($Comment) { $Driver | Update-Field -FieldName "Comment" -NewValue $Comment }
    if ($CustomField1) { $Driver | Update-Field -FieldName "Custom Field 1" -NewValue $CustomField1 }
    if ($CustomField2) { $Driver | Update-Field -FieldName "Custom Field 2" -NewValue $CustomField2 }
    if ($CustomField3) { $Driver | Update-Field -FieldName "Custom Field 3" -NewValue $CustomField3 }
    if ($CustomField4) { $Driver | Update-Field -FieldName "Custom Field 4" -NewValue $CustomField4 }


    if ($RiskBooster)
    {
        $RiskBoosterDiv = $Driver.FindElementsByClassName("step-label") | Where-Object Text -like "$RiskBooster"
        if ($NULL -eq $RiskBoosterDiv)
        {
            "Failed to find Risk Booster Div for Level:$RiskBooster"
        }
        else 
        {
            $RiskBoosterDiv.Click()    
        }
    }

    if ($EmployeeStartDate)
    {
        $DatePicker = $Driver.FindelementsById("datePicker")
        if ($NULL -eq $DatePicker)
        {
            throw "Failed to find datePicker for EmployeeStartDate"
        }
        else
        {
            $DatePicker.FindElementByTagName("input").SendKeys($EmployeeStartDate.ToString("MM/dd/yyyy"))
        }
        
    }

    # Submit the data
    $SubmitButton.Submit()
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
