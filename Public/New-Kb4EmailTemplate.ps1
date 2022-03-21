
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
        [Parameter(Mandatory=$TRUE)][String]$HTMLContent
    )

    $Hints = @{
        Url = "https://training.knowbe4.com/ui/phishing/email_templates/user/new"
        HtmlSourceClassName="cke_source"
        SaveButtonClassName="btn-primary"
    }

    # If a separate reply address wasn't specified, just use the sender.
    if ([String]::IsNullOrEmpty($ReplyTo)) { $ReplyTo = $SenderEmail }
    if ([String]::IsNullOrEmpty($ReplyToName)) { $ReplyToName = $SenderName }



    Enter-SeUrl -Driver $Driver -Url $Hints.Url


    $TheForm = $Driver.FindElementByTagName("form")
    if ($NULL -eq $TheForm) { throw "Failed to find the Form object with tag:" }

    # Get all fields from the form
    $Fields = $TheForm.FindElementsByClassName("form-control")

    # Populate the fields
    $Fields[0].SendKeys("$TemplateName")
    $Fields[1].SendKeys("$SenderEmail")
    $Fields[2].SendKeys("$SenderName")
    $Fields[3].SendKeys("$ReplyTo")
    $Fields[4].SendKeys("$ReplyToName")
    $Fields[5].SendKeys("$Subject")



    # Click the Source button on the editor
    $Driver.ExecuteScript("CKEDITOR.tools.callFunction(6,this);")

    
    # Paste in the source code of the email
    $EmailContentTextArea = $Driver.FindElementByClassName($Hints.HtmlSourceClassName)
    if ($NULL -eq $EmailContentTextArea) { throw "Failed to find HTML Source textarea with class:$($Hints.HtmlSourceClassName)" }
    $EmailContentTextArea.Click()


    # Script to set the value of the textarea
    $Script = "document.getElementsByClassName('$($Hints.HtmlSourceClassName)')[0].value = ``$HTMLContent``"
    $driver.ExecuteScript($Script)


    # Click the Source button on the editor to go to the preview mode
    $Driver.ExecuteScript("CKEDITOR.tools.callFunction(6,this);")

    # Wait a second to make sure the site is ready
    Start-Sleep -Seconds 1
    
    
    # TODO: Add an optional 'confirm' step to allow the user to make sure everything was imported correctly.

    # Press Submit to create the phishing email
    $SaveButton = $Driver.FindElementByClassName($Hints.SaveButtonClassName)
    if ($NULL -eq $SaveButton) { throw "Failed to find Save button with class:$($Hints.SaveButtonClassName)" }
    $SaveButton.Click()


    # TODO: Template category
}