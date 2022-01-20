Function Set-Kb4User
{
    [CmdletBinding()]
    Param(

        [Parameter(Mandatory=$True)][Object]$Driver,

        [Parameter(Mandatory=$True, ValueFromPipeline, ValueFromPipelineByPropertyName)][int]$id,

        [Parameter(Mandatory=$False)][String]$Email,
        [Parameter(Mandatory=$False)][String]$FirstName,
        [Parameter(Mandatory=$False)][String]$LastName,
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
        [Parameter(Mandatory=$False)][String]$CustomField4
    )
    Function Update-Field
    {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory=$True, ValueFromPipeline)][Object]$Driver,
            [Parameter(Mandatory=$True, ParameterSetName="ByName")][String]$FieldName,
            [Parameter(Mandatory=$True, ParameterSetName="ById")][String]$FieldId,
            [Parameter(Mandatory=$True)][String]$NewValue
        )
        if ($PSCmdlet.ParameterSetName -like "ByName")
        {
            $Field = $Driver.FindElementsByName("$FieldName")[0]
        }
        elseif ($PSCmdlet.ParameterSetName -like "ById")
        {
            $Field = $Driver.FindElementsById("$FieldId")[0]
        }

        if ($NULL -eq $Field)
        {
            throw "Failed to find field for $FieldName=$NewValue"
        }
        else {
            $Field.Clear()
            $Field.SendKeys($NewValue)
        }
    }

    # Navigate to the user edit page
    Enter-SeUrl -Driver $Driver -Url "https://training.knowbe4.com/ui/users/$id/details"


    # Find the submit button
    $sBtnClass = "btn-primary"
    $sBtnText = "Update User"
    $SubmitButton = $Driver.FindElementsByClassName("$sBtnClass") | Where-Object Text -like "$sBtnText" | Select-Object -First 1

    # If we couldn't find the submit button, terminate the function. They must have updated their site.
    if ($NULL -eq $SubmitButton)
    {
        throw "Failed to find submit button with class:'$sBtnClass' and text:'$sBtnText'"
    }


    # Update string fields
    if ($Email) { $Driver | Update-Field -FieldName "Email" -NewValue $Email }
    if ($FirstName) { $Driver | Update-Field -FieldName "First Name" -NewValue $FirstName }
    if ($LastName) { $Driver | Update-Field -FieldName "Last Name" -NewValue $LastName }
    if ($PhoneNumber) { $Driver | Update-Field -FieldName "Phone Number" -NewValue $PhoneNumber }
    if ($Extension) { $Driver | Update-Field -FieldName "Extension" -NewValue $Extension }
    if ($MobilePhoneNumber) { $Driver | Update-Field -FieldName "Mobile Phone Number" -NewValue $MobilePhoneNumber }
    if ($Location) { $Driver | Update-Field -FieldName "Location" -NewValue $Location }
    if ($Division) { $Driver | Update-Field -FieldName "Division" -NewValue $Division }
    if ($ManagerName) { $Driver | Update-Field -FieldName "Manager Name" -NewValue $ManagerName }
    if ($ManagerEmail) { $Driver | Update-Field -FieldName "Manager Email" -NewValue $ManagerEmail }
    if ($EmployeeNumber) { $Driver | Update-Field -FieldName "Employee Number" -NewValue $EmployeeNumber }
    if ($JobTitle) { $Driver | Update-Field -FieldName "Job Title" -NewValue $JobTitle }
    if ($Organization) { $Driver | Update-Field -FieldName "Organization" -NewValue $Organization }
    if ($Department) { $Driver | Update-Field -FieldName "Department" -NewValue $Department }
    if ($Comment) { $Driver | Update-Field -FieldName "Comment" -NewValue $Comment }
    if ($CustomField1) { $Driver | Update-Field -FieldName "Custom Field 1" -NewValue $CustomField1 }
    if ($CustomField2) { $Driver | Update-Field -FieldName "Custom Field 2" -NewValue $CustomField2 }
    if ($CustomField3) { $Driver | Update-Field -FieldName "Custom Field 3" -NewValue $CustomField3 }
    if ($CustomField4) { $Driver | Update-Field -FieldName "Custom Field 4" -NewValue $CustomField4 }


    if ($RiskBooster)
    {
        $RiskBoosterDiv = $Driver.FindElementsByClassName("step-label") | Where-Object Text -like "$RiskBooster"
        if ($NULL -eq $RiskBoosterDiv)
        {
            "Failed to find Risk Booster Div for Level:$RiskBooster"
        }
        else 
        {
            $RiskBoosterDiv.Click()    
        }
    }

    if ($EmployeeStartDate)
    {
        $DatePicker = $Driver.FindelementsById("datePicker")
        if ($NULL -eq $DatePicker)
        {
            throw "Failed to find datePicker for EmployeeStartDate"
        }
        else
        {
            $DatePicker.FindElementByTagName("input").SendKeys($EmployeeStartDate.ToString("MM/dd/yyyy"))
        }
        
    }

    # Submit the data
    $SubmitButton.Submit()
}

