<#
.SYNOPSIS 
    Gets the Risk Score history for a provided user

.PARAMETER Id
    The id of the user to get the Risk Score Summary for. If specified, one API call is made to fetch one row of data: v1/users/$Id/risk_score_history

.PARAMETER Email
    The email of the user to get the Risk Score Summary for. Multiple API calls are made to fetch all users, filter by Email, then get the risk score history for that user. Inefficient and if used alot, will exhaust your API access.
    
.PARAMETER Full
    Gets the entire history for the user. If not specified, it will only get the last 6 months.
#>
Function Get-KB4UserRiskSummary
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, ParameterSetName="UserId", ValueFromPipelineByPropertyName)][int]$Id,
        [Parameter(Mandatory=$True, ParameterSetName="Email")][String]$Email,
        [Parameter(Mandatory=$False)][Switch]$Full
    )

    # Make sure we're authenticated before proceeding
    Ensure-Connected -ErrorAction Stop


    # Construct the Invoke-Rest parameters from the host, token, and endpoint
    switch ($PSCmdlet.ParameterSetName)
    {
        "UserId"
        {
            $Params = $Script:KB4Connection.GetRequestParams("v1/users/$Id/risk_score_history")
            $Params.Queries["Full"] = $Full
            Invoke-RESTWithPagination @Params | Select-Object *, @{ Name = "id"; Expression = { $Id } } | Write-Output
        }
        
        "Email"
        {
            $Id = Get-Kb4Users | Where-Object email -like $Email | Select-Object -Expand Id
            $Params = $Script:KB4Connection.GetRequestParams("v1/users/$Id/risk_score_history")
            $Params.Queries["Full"] = $Full
            Invoke-RESTWithPagination @Params | Select-Object *, @{ Name = "id"; Expression = { $Id } } | Write-Output
        }
    }
}