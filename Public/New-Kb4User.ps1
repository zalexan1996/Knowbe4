
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
        URL = "https://training.knowbe4.com/ui/users/users/new"
        TableSearchURL = "https://training.knowbe4.com/ui/users/?search=$Email"

        EmailInput = "//input[@name='email']"
        FirstNameInput = "//input[@name='firstName']"
        LastNameInput = "//input[@name='lastName']"
        JobTitleInput = "//input[@name='jobTitle']"
        CreateButton = "//button[@id='submit-button']"


        CreatedUserLink = "//a[contains(@href, '/ui/users/') and contains(@href, '/details')]"
    }

    # If navigation failed, complain.
    if (!(TryNavigate -Driver $Driver -Url $Hints.Url)) {
        throw "Navigation to '$($Hints.Url)' failed.`nEnsure that the driver was properly authenticated."
    }


    (TryGetElement $Driver $Hints.EmailInput).SendKeys("$Email")
    (TryGetElement $Driver $Hints.FirstNameInput).SendKeys("$FirstName")
    (TryGetElement $Driver $Hints.LastNameInput).SendKeys("$LastName")
    (TryGetElement $Driver $Hints.CreateButton).Click()



    # Navigate to the new user's page to get the user id
    if (!(TryNavigate -Driver $Driver -Url $Hints.TableSearchURL -ExpectRedirection)) {
        throw "Navigation to '$($Hints.TableSearchURL)' failed.`nEnsure that the driver was properly authenticated."
    }

    # Wait for the table to finish loading
    while ($Driver.FindElementsByTagName("table").GetAttribute("aria-busy") -like "true")
    {
        Start-Sleep -Milliseconds 250
    }

    # Extract the user id from the href
    $newUserUrl = (TryGetElement $Driver $Hints.CreatedUserLink).GetAttribute("href")
    $newUserId = [Regex]::Match($newUserUrl, "(?<=/)\d+").Value

    # Make sure the user id is valid.
    if ([String]::IsNullOrEmpty($newUserId))
    {
        throw "Failed to extract user id for newly created user: $Email"   
    }

    # Since Set-Kb4User uses the same parameters that New-Kb4Users uses, we can just splat the hashtable of used parameters
    Set-Kb4User -id $newUserId @PSBoundParameters
}
