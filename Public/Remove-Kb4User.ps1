Function Remove-Kb4User
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)][Object]$Driver,
        [Parameter(Mandatory=$True)][String]$Email,
        [Parameter(Mandatory=$True, ParameterSetName="Archive")][Switch]$Archive,
        [Parameter(Mandatory=$True, ParameterSetName="Delete")][Switch]$Delete
    )

    # Search for this user in Kb4
    Enter-SeUrl -Url "https://training.knowbe4.com/ui/users/?search=$Email" -Driver $Driver

    Start-Sleep -Milliseconds 1000
    $UserRow = $Driver.FindElementsByTagName("tr") | Where-Object { $_.Text -like "*$Email*"}
    if ($NULL -eq $UserRow)
    {
        Throw "Couldn't find row entry for $Email"
    }
    
    # Click the drop-down button
    $UserRow.FindElementsByTagName("button").Click()
    
    # Search for the archive button. If the user is already archived, this won't exist and we'll just move on to the delete button.
    $ArchiveLI = $UserRow.FindElementsByTagName("li") | Where-Object { $_.GetAttribute("role") -like "presentation" -and $_.Text -like "Archive" }
    if ($ArchiveLI)
    {
        # click Archive
        $ArchiveLI.Click()
    
        # Confirm archival
        $ConfirmBtn = $Driver.FindElementsByTagName("button") | Where-Object { $_.Text -like "Confirm" }
        if ($ConfirmBtn)
        {
            $ConfirmBtn.Click()
        }
    }


    # Permanently delete
    if ($Delete.IsPresent)
    {
        Start-Sleep -Milliseconds 1000
        
        # Click the drop-down button again
        $UserRow.FindElementsByTagName("button").Click()
    
        # Get the Delete button
        $DeleteLI = $UserRow.FindElementsByTagName("li") | Where-Object {$_.GetAttribute("role") -like "presentation" -and $_.Text -like "Delete" }
        if ($DeleteLI)
        {
            # click Delete
            $DeleteLI.Click()
    
            # Confirm Delete
            $ConfirmBtn = $Driver.FindElementsByTagName("button") | Where-Object { $_.Text -like "Confirm" }
            if ($ConfirmBtn)
            {
                $ConfirmBtn.Click()
            }
        }
    }
}


