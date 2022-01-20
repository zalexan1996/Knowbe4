Function Ensure-Connected
{
    # Use CmdletBinding to give use access to ErrorAction
    [CmdletBinding()]Param()

    
    # Throw exception if the token is null
    if (!$Script:KB4Connection.IsConnected())
    {
        throw "You must connect to KB4 with Connect-Kb4 before running any other KB4 commands"
    }
}