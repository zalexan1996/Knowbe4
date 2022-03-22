function SetElementProperty
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$TRUE)][Object]$Driver,
        [Parameter(Mandatory=$TRUE)][String]$XPath,
        [Parameter(Mandatory=$True)][String]$Property,
        [Parameter(Mandatory=$True)][String]$NewValue
    )

    $Script = @"
let elements = document.evaluate("$XPath", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);  

for (var i = 0; i < elements.snapshotLength; i++) {
    elements.snapshotItem(i).$Property = "$newValue";
}
"@

    $Driver.ExecuteScript($script)

}