<#
.SYNOPSIS
    Gets all groups defined in Knowbe4. Includes regular groups and smart groups. Output for smart groups does not contain the membership filter.
    Requires authentication with Connect-KB4.

.PARAMETER id
    The integer id for a specific group. If not specified, all groups will be received.
    
.PARAMETER Status
    Filter for Active or Archived groups

.OUTPUTS
    @{
        int         id
        string      name
        string      group_type
        string      provisioning_guid
        int         member_count
        float       current_risk_score
        string      status
    }

#>
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