Function TryGetElement
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$TRUE)][Object]$Driver,
        [Parameter(Mandatory=$TRUE)][String]$xpath
    )
    
    $element = $Driver.FindElementByXPath($xpath)
    if ($NULL -eq $element)
    {
        throw "Failed to find element with xpath:'$xpath'"
    }

    return $element
}


Function TryGetElements
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$TRUE)][Object]$Driver,
        [Parameter(Mandatory=$TRUE)][String]$xpath
    )
    
    $elements = $Driver.FindElementsByXPath($xpath)
    if ($NULL -eq $elements -or $elements.Count -eq 0)
    {
        throw "Failed to find elements with xpath:'$xpath'"
    }

    return $elements
}
