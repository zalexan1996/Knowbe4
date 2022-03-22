Function Set-Kb4User
{
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$True)][Object]$Driver,

        [Parameter(Mandatory=$True, ValueFromPipeline, ValueFromPipelineByPropertyName)][int]$id,

        [Parameter(Mandatory=$False)][String]$Email,
        [Parameter(Mandatory=$False)][String]$FirstName,
        [Parameter(Mandatory=$False)][String]$LastName,
        [Parameter(Mandatory=$False)][ValidateSet("Low", "Normal", "High", "Highest")][String]$RiskBooster = "Normal",
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
    Function Update-Field
    {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory=$True, ValueFromPipeline)][Object]$Driver,
            [Parameter(Mandatory=$True, ParameterSetName="ByName")][String]$XPath,
            [Parameter(Mandatory=$True)][String]$NewValue
        )
        $Field = $Driver.FindElementByXPath($XPath)
        try { $Field.Clear() } catch {}     # Some fields don't need to be cleared so ignore any errors.
        $Field.SendKeys($NewValue)
    }
    
    $Hints = @{
        URL = "https://training.knowbe4.com/ui/users/$id/details"
        Email = "//input[@name='Email']"
        FirstName = "//input[@name='First Name']"
        LastName = "//input[@name='Last Name']"
        PhoneNumber = "//input[@name='Phone Number']"
        Extension = "//input[@name='Extension']"
        MobilePhoneNumber = "//input[@name='Mobile Phone Number']"
        Location = "//input[@name='Location']"
        Division = "//input[@name='Division']"
        ManagerName = "//input[@name='Manager Name']"
        ManagerEmail = "//input[@name='Manager Email']"
        EmployeeNumber = "//input[@name='Employee Number']"
        JobTitle = "//input[@name='Job Title']"
        Organization = "//input[@name='Organization']"
        Department = "//input[@name='Department']"
        Comment = "//textarea[@name='Comment']"
        CustomField1 = "//input[@name='Custom Field 1']"
        CustomField2 = "//input[@name='Custom Field 2']"
        CustomField3 = "//input[@name='Custom Field 3']"
        CustomField4 = "//input[@name='Custom Field 4']"
        CustomDate1 = "//span[@qa-id='Custom Date 1']//input[@class='form-control']"
        CustomDate2 = "//span[@qa-id='Custom Date 2']//input[@class='form-control']"

        RiskBooster = "//div[contains(@class, 'step-label') and text()='$RiskBooster']"
        EmployeeStartDate = "//div[@id='datePicker']//input[@class='form-control']"
        EmployeeStartTime = "//div[@id='timePicker']//input[@class='form-control']"

        SubmitButton = "//button[@qa-id='editUser']"
    }

    # Navigate to the user edit page
    if (!(TryNavigate -Driver $Driver -Url $Hints.Url)) {
        throw "Navigation to '$($Hints.Url)' failed.`nEnsure that the driver was properly authenticated."
    }



    # Update string fields
    if ($Email)             { $Driver | Update-Field -XPath $Hints.Email -NewValue $Email }
    if ($FirstName)         { $Driver | Update-Field -XPath $Hints.FirstName -NewValue $FirstName }
    if ($LastName)          { $Driver | Update-Field -XPath $Hints.LastName -NewValue $LastName }
    if ($PhoneNumber)       { $Driver | Update-Field -XPath $Hints.PhoneNumber -NewValue $PhoneNumber }
    if ($Extension)         { $Driver | Update-Field -XPath $Hints.Extension -NewValue $Extension }
    if ($MobilePhoneNumber) { $Driver | Update-Field -XPath $Hints.MobilePhoneNumber -NewValue $MobilePhoneNumber }
    if ($Location)          { $Driver | Update-Field -XPath $Hints.Location -NewValue $Location }
    if ($Division)          { $Driver | Update-Field -XPath $Hints.Division -NewValue $Division }
    if ($ManagerName)       { $Driver | Update-Field -XPath $Hints.ManagerName -NewValue $ManagerName }
    if ($ManagerEmail)      { $Driver | Update-Field -XPath $Hints.ManagerEmail -NewValue $ManagerEmail }
    if ($EmployeeNumber)    { $Driver | Update-Field -XPath $Hints.EmployeeNumber -NewValue $EmployeeNumber }
    if ($JobTitle)          { $Driver | Update-Field -XPath $Hints.JobTitle -NewValue $JobTitle }
    if ($Organization)      { $Driver | Update-Field -XPath $Hints.Organization -NewValue $Organization }
    if ($Department)        { $Driver | Update-Field -XPath $Hints.Department -NewValue $Department }
    if ($Comment)           { $Driver | Update-Field -XPath $Hints.Comment -NewValue $Comment }
    if ($CustomField1)      { $Driver | Update-Field -XPath $Hints.CustomField1 -NewValue $CustomField1 }
    if ($CustomField2)      { $Driver | Update-Field -XPath $Hints.CustomField2 -NewValue $CustomField2 }
    if ($CustomField3)      { $Driver | Update-Field -XPath $Hints.CustomField3 -NewValue $CustomField3 }
    if ($CustomField4)      { $Driver | Update-Field -XPath $Hints.CustomField4 -NewValue $CustomField4 }
    if ($CustomDate1)       { $Driver | Update-Field -XPath $Hints.CustomDate1 -NewValue $CustomDate1.ToString("MM/dd/yyyy") }
    if ($CustomDate2)       { $Driver | Update-Field -XPath $Hints.CustomDate2 -NewValue $CustomDate2.ToString("MM/dd/yyyy") }

    if ($EmployeeStartDate) { $Driver | Update-Field -XPath $Hints.EmployeeStartDate -NewValue $EmployeeStartDate.ToString("MM/dd/yyyy") }
    if ($EmployeeStartDate) { $Driver | Update-Field -XPath $Hints.EmployeeStartTime -NewValue $EmployeeStartDate.ToString("H/mm") }


    (TryGetElement $Driver $Hints.RiskBooster).Click()


    # Submit the data
    (TryGetElement $Driver $Hints.SubmitButton).Click()
}