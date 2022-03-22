Function Get-Kb4EmailTemplateCategory
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$TRUE)][Object]$Driver
    )

    $Hints = @{
        Url = "https://training.knowbe4.com/ui/phishing/email_templates/user/all"
        Category = "//span[@class='cat-name']"
    }

    # If navigation failed, complain.
    if (!(TryNavigate -Driver $Driver -Url $Hints.Url)) {
        throw "Navigation to '$($Hints.Url)' failed.`nEnsure that the driver was properly authenticated."
    }

    TryGetElements $Driver $Hints.Category | Write-Output
}
