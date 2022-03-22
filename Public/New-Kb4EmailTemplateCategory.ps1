Function New-Kb4EmailTemplateCategory
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$TRUE)][Object]$Driver,
        [Parameter(Mandatory=$TRUE)][String]$Category
    )
    
    # xpath's for finding the correct elements.
    $Hints = @{
        AddButton = "//button[@qa-id='newCategoryAdd']"
        CatNameInput = "//input[@qa-id='newCategoryInput']"
        SaveButton = "//button[@qa-id='newCategorySave']"
    }


    # Make sure that our 'new' category doesn't exist already.
    # Our script will then conveniently be at the right url.
    if ((Get-Kb4EmailTemplateCategory -Driver $Driver) -contains $Category) {
        throw "Category already exists!"
    }

    
    # Click the add category button
    (TryGetElement $Driver $Hints.AddButton).Click()

    # Type the category string into the category text box
    (TryGetElement $Driver $Hints.CatNameInput).SendKeys($Category)

    # Click the save category button
    (TryGetElement $Driver $Hints.SaveButton).Click()

}