Function Invoke-RESTWithPagination
{
<#
.SYNOPSIS
A wrapper for Invoke-RestMethod that gets ALL content despite pagination constraints
.PARAMETER URI
The URI to connect to. This will be passed to the Invoke-RESTMethod call without modification.
.PARAMETER Headers
An optional set of headers. In the case of the Knowbe4 API, we need to pass in our token and an entry to accept a JSON response.
.EXAMPLE
You don't need to call this function directly. Once this is converted to a Module, you won't be able to anyways.
#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)][String]$URI,
        [Parameter(Mandatory=$False)][System.Collections.IDictionary]$Headers,
        [Parameter(Mandatory=$False)][System.Collections.IDictionary]$Queries,
        [Parameter(Mandatory=$False)][Switch]$IgnorePagination
    )



    # Add Pagination params to the queries
    $Queries["per_page"] = 100
    $Queries["page"] = 0

    do
    {
        # Increment the page for a new run
        $Queries["page"] += 1

        # Convert the hashtable representation to an array of "key=value"s
        $Constructed = @()
        foreach ($Key in $Queries.Keys) { $Constructed += [String]($Key + "=" + $Queries[$Key]) }

        # Append query params to the URI and join them with &
        $FinalURL = "$($URI)?$($Constructed -join "&")"

        # Output the results from the API and save the response in a temp variable so we can see the response length
        Invoke-RestMethod -URI "$FinalURL" -Headers $Headers -Method Get | Tee-Object -Variable "Response" | Write-Output

        # If nothing was returns this run, then we are at the end
    } while ($Response.Length -gt 0 -and !$IgnorePagination)
}
# SIG # Begin signature block
# MIIIXQYJKoZIhvcNAQcCoIIITjCCCEoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU4u6zDV7cyB/wC7rwodvOI0wp
# YaCgggW7MIIFtzCCBJ+gAwIBAgITIAAAAtaXwewHS8gOOgAAAAAC1jANBgkqhkiG
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
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRhzK7B46fMFNvhJPBK2AGksWiiEjAN
# BgkqhkiG9w0BAQEFAASCAQB05C2ipHEQ9uBikZXXvdwo05XPQeqBEbxfDBLuH9Ys
# CoxG+vLRE5TNhJZ+hB/faDIvDVNjkxvQj9w66IO5mJZchZN/aqjCC9XvGuXQZqzE
# CDaLP7zz46ly3vgu77yFn3Hz3+SL1dpKkjFX1ji5+F+smpe9uApHPNQ0SMjhrQsi
# 2XHc86f/VUK84W2qwgIpvpb2diIMI2Io2b4hXHq1lkso0zwl0jUXj7qRJZfIp0lY
# QJ+ApgYTAezu2lRoyco4Z5yANJfpiu8sTEBubZsr3BBrz8Y0aOzsYSTpaWbwBFRR
# p7dIySVOSiR9EmGfylnFf6oA8vukc9gYkDLBL1Wbhu6H
# SIG # End signature block
