
Function New-Kb4User
{
    [CmdletBinding()]
    Param(
        # The web driver
        [Parameter(Mandatory=$True)][Object]$Driver,

        # Mandatory Values for new creation
        [Parameter(Mandatory=$True)][String]$Email,
        [Parameter(Mandatory=$True)][String]$FirstName,
        [Parameter(Mandatory=$True)][String]$LastName,
        
        # Extended properties sent to Set-Kb4User
        [Parameter(Mandatory=$False)][ValidateSet("Low", "Normal", "High", "Highest")][String]$RiskBooster,
        [Parameter(Mandatory=$False)][String]$PhoneNumber,
        [Parameter(Mandatory=$False)][String]$Extension,
        [Parameter(Mandatory=$False)][String]$MobilePhoneNumber,
        [Parameter(Mandatory=$False)][String]$Location,
        [Parameter(Mandatory=$False)][String]$Division,
        [Parameter(Mandatory=$False)][String]$ManagerName,
        [Parameter(Mandatory=$False)][String]$ManagerEmail,
        [Parameter(Mandatory=$False)][String]$EmployeeNumber,
        [Parameter(Mandatory=$False)][String]$JobTitle,
        [Parameter(Mandatory=$False)][String]$Organization,
        [Parameter(Mandatory=$False)][String]$Department,
        [Parameter(Mandatory=$False)][String]$Comment,
        [Parameter(Mandatory=$False)][DateTime]$EmployeeStartDate,
        [Parameter(Mandatory=$False)][String]$CustomField1,
        [Parameter(Mandatory=$False)][String]$CustomField2,
        [Parameter(Mandatory=$False)][String]$CustomField3,
        [Parameter(Mandatory=$False)][String]$CustomField4,
        [Parameter(Mandatory=$False)][DateTime]$CustomDate1,
        [Parameter(Mandatory=$False)][DateTime]$CustomDate2
    )

    # Edit these if the website changes their design.
    $Hints = @{
        EmailInputId = "__BVID__103"
        firstNameInputId = "__BVID__105"
        lastNameInputId = "__BVID__107"
        createButtonClass = "btn-primary"
        createButtonText = "Create User"
        URL = "https://training.knowbe4.com/ui/users/users/new"
    }


    # Go to the create user page
    Enter-SeUrl -Driver $Driver -Url $Hints["URL"]

    # Search for the inputs
    $emailInput = $Driver.FindElementById($Hints["EmailInputId"])
    $firstNameInput = $Driver.FindElementById($Hints["firstNameInputId"])
    $lastNameInput = $Driver.FindElementById($Hints["lastNameInputId"])
    $createButton = $Driver.FindElementByClassName($Hints["createButtonClass"]) | Where-Object Text -like $Hints["createButtonText"]

    # Make sure the inputs are valid.
    if ($NULL -eq $emailInput) { throw "Failed to find Email input with id:'$($Hints["EmailInputId"])'"}
    if ($NULL -eq $firstNameInput) { throw "Failed to find First Name input with id:'$($Hints["firstNameInputId"])'"}
    if ($NULL -eq $lastNameInput) { throw "Failed to find Last Name input with id:'$($Hints["lastNameInputId"])'"}
    if ($NULL -eq $createButton) { throw "Failed to find Create User button with class:'$($Hints["createButtonClass"])' and Text:'$($Hints["createButtonText"])'"}

    # Send the data
    $emailInput.SendKeys($Email)
    $firstNameInput.SendKeys($FirstName)
    $lastNameInput.SendKeys($LastName)
    $createButton.Click()

    Start-Sleep -Milliseconds 2000

    # Navigate to the new user's page to get the user id
    Enter-SeUrl -Url "https://training.knowbe4.com/ui/users/?search=$Email" -Driver $Driver

    Start-Sleep -Milliseconds 2000

    # Get the full URL to the new users page
    $NewUserLink = $Driver.FindElementsByTagName("a") | Where-Object { $_.GetAttribute("href") -like "https://training.knowbe4.com/ui/users/*/details" }
    
    # Make sure we got a link to the new users's page
    if ($NULL -eq $NewUserLink)
    {
        throw "Failed to find user page for newly created user: $Email"  
    }

    # Extract the user id from the href
    $user_id = (Select-String -Pattern "(?<=/)\d+" -InputObject $NewUserLink.GetAttribute("href") -AllMatches).Matches.Value

    # Make sure the user id is valid.
    if ([String]::IsNullOrEmpty($user_id))
    {
        throw "Failed to extract user id for newly created user: $Email"   
    }

    # Since Set-Kb4User uses the same parameters that New-Kb4Users uses, we can just splat the hashtable of used parameters
    Set-Kb4User -id $user_id @PSBoundParameters
}
