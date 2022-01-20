Function Get-KB4Groups
{
    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$True, ParameterSetName="Id", ValueFromPipeline, ValueFromPipelineByPropertyName)][Int]$id,
        [Parameter(Mandatory=$False)][ValidateSet("", "Active", "Archived")][String]$Status
    )
    
    # Make sure we're authenticated before proceeding
    Ensure-Connected -ErrorAction Stop


    # Construct the Invoke-Rest parameters from the host, token, and endpoint
    switch ($PSCmdlet.ParameterSetName)
    {
        "All"
        {
            $Params = $Script:KB4Connection.GetRequestParams("v1/groups")
            if ($Status)
            {
                $Params.Queries["Status"] = $Status
            }

            Invoke-RESTWithPagination @Params | Write-Output
        }
        "Id"
        {
            $Params = $Script:KB4Connection.GetRequestParams("v1/groups/$id")
            Invoke-RESTWithPagination @Params | Write-Output
        }
    }
}