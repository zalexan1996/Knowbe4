Function TryNavigate
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$TRUE)][Object]$Driver,
        [Parameter(Mandatory=$TRUE)][String]$Url,
        [Parameter(Mandatory=$False)][Switch]$ExpectRedirection,
        [Parameter(Mandatory=$False)][Switch]$ForceNavigation
    )

    if (!$ForceNavigation -and $Driver.Url -Like $Url)
    {
        return $TRUE
    }
    # Browse to the page
    Enter-SeUrl -Driver $Driver -Url $Url

    # Wait until the document has finished loading
    while ($Driver.ExecuteScript("return document.readyState") -notlike "complete") { 
        Start-Sleep -Seconds 1 
    }

    # If we expect redirection, then the URL should be different than what was provided.
    if ($ExpectRedirection) {
        Start-Sleep -Seconds 2
        return $Url -notlike $Driver.Url
    }

    # If we don't expect redirection, then the URL should be the same as what was provided.
    else {
        return $Url -like $Driver.Url
    }
}