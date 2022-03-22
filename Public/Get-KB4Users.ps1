<#
.SYNOPSIS
Lists all users in the Knowbe4 database

.PARAMETER id
    The id of a user to get
#> 
function Get-KB4Users {
    [CmdletBinding(DefaultParameterSetName="All")]
    Param (
        [Parameter(Mandatory=$True, ParameterSetName="User", ValueFromPipeline, ValueFromPipelineByPropertyName)][Alias("user_id")][int]$id,
        [Parameter(Mandatory=$False)][int]$group_id,
        [Parameter(Mandatory=$False)][ValidateSet("", "Active", "Archived")][String]$Status,
        [Parameter(Mandatory=$False)][Switch]$ExpandGroup
    )

    # Make sure we're authenticated before proceeding
    Ensure-Connected -ErrorAction Stop


    # Construct the Invoke-Rest parameters from the host, token, and endpoint
    switch ($PSCmdlet.ParameterSetName)
    {
        "All"
        {
            $Params = $Script:KB4Connection.GetRequestParams("v1/users")
            if ($Status)      {   $Params.Queries["Status"]    = $Status     }
            if ($group_id)    {   $Params.Queries["group_id"]  = $group_id   }
            if ($ExpandGroup) {   $Params.Queries["expand"]    = "group"     }

            Invoke-RESTWithPagination @Params | Write-Output
        }
        "User"
        {
            $Params = $Script:KB4Connection.GetRequestParams("v1/users/$id")
            Invoke-RESTWithPagination @Params -IgnorePagination | Write-Output
        }
    }
}