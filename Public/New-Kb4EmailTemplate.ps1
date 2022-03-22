
Function New-Kb4EmailTemplate
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$TRUE)][Object]$Driver,
        [Parameter(Mandatory=$TRUE)][String]$TemplateName,
        [Parameter(Mandatory=$TRUE)][String]$SenderEmail,
        [Parameter(Mandatory=$TRUE)][String]$SenderName,
        [Parameter(Mandatory=$FALSE)][String]$ReplyTo,
        [Parameter(Mandatory=$FALSE)][String]$ReplyToName,
        [Parameter(Mandatory=$TRUE)][String]$Subject,
        [Parameter(Mandatory=$TRUE)][String]$HTMLContent,
        [Parameter(Mandatory=$False)][String]$Category
    )

    # If a separate reply address wasn't specified, just use the sender.
    if ([String]::IsNullOrEmpty($ReplyTo)) { $ReplyTo = $SenderEmail }
    if ([String]::IsNullOrEmpty($ReplyToName)) { $ReplyToName = $SenderName }


    $Hints = @{
        Url = "https://training.knowbe4.com/ui/phishing/email_templates/user/new"

        # Hints for creating the email template
        Fields = "//input[@class='form-control']"
        SourceButton = "//a[@title='Source']"
        SourceTextArea="//textarea"
        SaveButton="//button[@qa-id='save']"
        SetContentScript = "document.getElementsByClassName('cke_source')[0].value = ``$HTMLContent``"

        # Hints for setting the category
        DraftButton = "//div[@qa-id='categoryList']//span[@title='Drafts']"
        Checkbox = "//tr[contains(@class, 'template-item')]//a[text()='$TemplateName']/../../..//input"
        CategoryOption = "//option[text()='$Category']"
        MoveButton = "//button[@qa-id='selectActionMove']"
    }

    if (!(TryNavigate -Driver $Driver -Url $Hints.Url)) {
        throw "Navigation to '$($Hints.Url)' failed.`nEnsure that the driver was properly authenticated."
    }


    # Populate the fields
    $Fields = (TryGetElements $Driver $Hints.Fields)
        $Fields[0].SendKeys("$TemplateName")
        $Fields[1].SendKeys("$SenderEmail")
        $Fields[2].SendKeys("$SenderName")
        $Fields[3].SendKeys("$ReplyTo")
        $Fields[4].SendKeys("$ReplyToName")
        $Fields[5].SendKeys("$Subject")


    # Click the source button
    (TryGetElement $Driver $Hints.SourceButton).Click()

    
    # Paste in the source code of the email
    (TryGetElements $Driver $Hints.SourceTextArea)[1].Click()


    # Script to set the value of the textarea
    $driver.ExecuteScript($Hints.SetContentScript)


    # Click the Source button on the editor to go to the preview mode
    (TryGetElement $Driver $Hints.SourceButton).Click()


    # Wait a second to make sure the site is ready
    Start-Sleep -Seconds 1
    

    # Press Submit to create the phishing email
    (TryGetElement $Driver $Hints.SaveButton).Click()


    # TODO: Add an optional 'confirm' step to allow the user to make sure everything was imported correctly.
    # TODO: Template category

    # Create the category if it doesn't exist.
    if ($Category)
    {
        # Create the new category if it's not already created
        $Categories = Get-Kb4EmailTemplateCategory $Driver
        if ($Categories -notcontains $Category) {
            New-Kb4EmailTemplateCategory -Driver $Driver -Category $Category
        }
    
    
        ### Add the new email to the category.

        # Open the drafts
        (TryGetElement $Driver $Hints.DraftButton).Click()

        # Select the newly created email
        (TryGetElements $Driver $Hints.Checkbox).Click()

        # Wait for the animation to finish
        Start-Sleep -Milliseconds 500

        # Change the category
        (TryGetElements $Driver $Hints.CategoryOption).Click()

        # Click Move
        (TryGetElements $Driver $Hints.MoveButton).Click()
    }

}