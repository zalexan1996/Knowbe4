Function Remove-Kb4User
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)][Object]$Driver,
        [Parameter(Mandatory=$True)][String]$Email,
        [Parameter(Mandatory=$True, ParameterSetName="Archive")][Switch]$Archive,
        [Parameter(Mandatory=$True, ParameterSetName="Delete")][Switch]$Delete
    )

    # Search for this user in Kb4
    Enter-SeUrl -Url "https://training.knowbe4.com/ui/users/?search=$Email" -Driver $Driver


    # Wait for the table to finish loading
    while ($driver.executeScript("return document.readyState") -notlike "complete" -or $Driver.FindElementsByTagName("table").GetAttribute("aria-busy") -like "true")
    {
        Start-Sleep -Milliseconds 250
    }

    $UserRow = $Driver.FindElementsByTagName("tr") | Where-Object { $_.Text -like "*$Email*"}
    if ($NULL -eq $UserRow)
    {
        Throw "Couldn't find row entry for $Email"
    }
    
    # Click the drop-down button
    $UserRow.FindElementsByTagName("button").Click()
    
    # Search for the archive button. If the user is already archived, this won't exist and we'll just move on to the delete button.
    $ArchiveLI = $UserRow.FindElementsByTagName("li") | Where-Object { $_.GetAttribute("role") -like "presentation" -and $_.Text -like "Archive" }
    if ($ArchiveLI)
    {
        # click Archive
        $ArchiveLI.Click()
    
        # Confirm archival
        $ConfirmBtn = $Driver.FindElementsByTagName("button") | Where-Object { $_.Text -like "Confirm" }
        if ($ConfirmBtn)
        {
            $ConfirmBtn.Click()
        }
    }


    # Permanently delete
    if ($Delete.IsPresent)
    {
        Start-Sleep -Milliseconds 1000
        
        # Click the drop-down button again
        $UserRow.FindElementsByTagName("button").Click()
    
        # Get the Delete button
        $DeleteLI = $UserRow.FindElementsByTagName("li") | Where-Object {$_.GetAttribute("role") -like "presentation" -and $_.Text -like "Delete" }
        if ($DeleteLI)
        {
            # click Delete
            $DeleteLI.Click()
    
            # Confirm Delete
            $ConfirmBtn = $Driver.FindElementsByTagName("button") | Where-Object { $_.Text -like "Confirm" }
            if ($ConfirmBtn)
            {
                $ConfirmBtn.Click()
            }
        }
    }
}



# SIG # Begin signature block
# MIIIXQYJKoZIhvcNAQcCoIIITjCCCEoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUTgxfawpMar086MmmG+wCFJOr
# lq2gggW7MIIFtzCCBJ+gAwIBAgITIAAAAtaXwewHS8gOOgAAAAAC1jANBgkqhkiG
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSZ7d/mPfP6cxbZxfb6O9/YjzX2RzAN
# BgkqhkiG9w0BAQEFAASCAQDnhMKB51VUaqHWs6D+5Z1tXv5krYXT436VrlvlpJP8
# zoJLbn0m5Of56wG0cLnDWyQ/M4BPvBJv1rT3lNoTHxtoVfVCXesQQqpsBOnK9qgc
# 65YuV4ckgjQgDyxSC+dEJFlQYevbJGiH1CHe/HQvhxDwuxf5fAQlLRmVF2dj/21L
# sYvJcBD9s9sRcBCVNNhl4SphgUeq7pzPIrrT6ozZ2eop8a3Qb4iPc6pYVJv9HRFX
# jjO+APBH9r7RUrHAos7O0JqNJLGi9MoiPzW1yVVF6sEA1fNlkFVTEkgUCmVZSQEt
# /jbnekf1IABRsAzZ5ZpuaUn3tywvglppCyiTjcs9vsaO
# SIG # End signature block
