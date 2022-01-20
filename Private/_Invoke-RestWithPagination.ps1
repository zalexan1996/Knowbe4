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
        [Parameter(Mandatory=$False)][System.Collections.IDictionary]$Queries
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
    } while ($Response.Length -gt 0)
}