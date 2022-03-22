class KB4Connection
{
    [String]$Token
    [String]$HostURL
    [System.Collections.IDictionary]$Headers

    KB4Connection($token, $hostUrl)
    {
        $this.Token = $token
        $this.HostURL = $hostUrl
        $this.Headers = @{
            "Authorization" = "Bearer " + $this.Token
            "Accept" = "application/json"
        }
    }

    [System.Collections.IDictionary]GetRequestParams($endpoint)
    {
        return @{
            "URI" = @($this.HostURL, $endpoint) -join '/'
            "Queries" = @{}
            "Headers" = $this.Headers
        }
    }

    [Bool]IsConnected()
    {
        return $this.Token -and $this.HostURL
    }

}