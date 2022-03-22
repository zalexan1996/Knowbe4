Function Remove-Kb4User
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)][Object]$Driver,
        [Parameter(Mandatory=$True)][String]$Email,
        [Parameter(Mandatory=$True, ParameterSetName="Archive")][Switch]$Archive,
        [Parameter(Mandatory=$True, ParameterSetName="Delete")][Switch]$Delete
    )
    $Hints = @{
        Url = "https://training.knowbe4.com/ui/users/?search=$Email"
        DropDownButton = "//table//tr//button"
        ArchiveButton = "//a[@class='dropdown-item' and contains(text(), 'Archive')]"
        DeleteButton = "//a[@class='dropdown-item' and contains(text(), 'Delete')]"
    }
    
    # If navigation failed, complain.
    if (!(TryNavigate -Driver $Driver -Url $Hints.Url)) {
        throw "Navigation to '$($Hints.Url)' failed.`nEnsure that the driver was properly authenticated."
    }

    # Wait for the table to finish loading
    while ($driver.executeScript("return document.readyState") -notlike "complete" -or $Driver.FindElementsByTagName("table").GetAttribute("aria-busy") -like "true")
    {
        Start-Sleep -Milliseconds 250
    }

    # Click the drop-down button
    (TryGetElement $Driver $Hints.DropDownButton).Click()
    
    # Search for the archive button. If the user is already archived, this won't exist and we'll just move on to the delete button.
    $Driver.FindElementsByTagName("li") | Where-Object {
        $_.GetAttribute("role") -like "presentation" -and $_.Text -like "Archive" 
    } | Foreach-Object {
        $_.Click()
    }

    # Confirm archival
    (TryGetElement $Driver "//button[text()='Confirm']").Click()

    # Permanently delete
    if ($Delete.IsPresent)
    {
        Start-Sleep -Milliseconds 1000

        # Click the drop-down button
        (TryGetElement $Driver $Hints.DropDownButton).Click()
    
        # Click the Delete button
        $Driver.FindElementsByTagName("li") | Where-Object {
            $_.GetAttribute("role") -like "presentation" -and $_.Text -like "Delete" 
        } | Foreach-Object {
            $_.Click()
        }

        # Confirm Delete
        (TryGetElement $Driver "//button[text()='Confirm']").Click()
    }
}