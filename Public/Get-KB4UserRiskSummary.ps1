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
            $Params = $Script:KB4Connection.GetRequestParams("v1/users/$($UserId)/risk_score_history")
            Invoke-RESTWithPagination @Params | Write-Output
        }
        
        "Email"
        {
            $UserId = Get-Kb4Users | Where-Object email -like $Email
            $Params = $Script:KB4Connection.GetRequestParams("v1/users/$($UserId)/risk_score_history")
            Invoke-RESTWithPagination @Params | Write-Output
        }
    }
}