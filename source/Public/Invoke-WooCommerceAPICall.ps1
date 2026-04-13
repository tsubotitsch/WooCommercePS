function Invoke-WooCommerceAPICall {
    
    [CmdletBinding()]
    [OutputType([PSObject])]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "The relative url of the WooCommerce API e.g. /products")]
        $RelativeUrl,
        [Parameter(Mandatory = $true, HelpMessage = "The HTTP Method to use e.g. GET")]
        [ValidateSet("GET", "POST", "PUT", "DELETE")]
        $Method,
        $Headers = $script:woocommerceBase64AuthInfo,
        $Body = $null
    )

    # construct the absolute url
    $url = $script:woocommerceUrl + "/" + $script:woocommerceApiPrefix + $RelativeUrl
    Write-Debug " RelativeUrl: $RelativeUrl"
    Write-Debug "$Method $url"

    try {
        $invokeParams = @{
            Method                  = $Method
            Uri                     = "$url"
            Headers                 = $script:woocommerceBase64AuthInfo
            Body                    = $Body
            ResponseHeadersVariable = 'responseHeaders'
            ContentType             = 'application/json'
        }
        $result = Invoke-RestMethod @invokeParams

        if ($result) {
            # loop trough all following pages and add to result if available
            if (($responseHeaders.'X-WP-TotalPages') -and ($url -notlike '*page=*')) {
                Write-Debug -Message "Link: $($responseHeaders.link)"

                Write-Debug -Message "Total#: $($responseHeaders.'X-WP-Total')"
                Write-Debug -Message "TotalPages: $($responseHeaders.'X-WP-TotalPages')"
                $i = 2
                while ($i -le [int]($responseHeaders.'X-WP-TotalPages'[0])) {
                    Write-Debug -Message "GET $($url)?page=$i"
                    if ($url -like '*?*') {
                        $invokeParams.Uri = "$url&page=$i"
                    }
                    else {
                        $invokeParams.Uri = "$url?page=$i"
                    }
                    $result += Invoke-RestMethod @invokeParams
                    $i++
                }
            }
            if ($responseHeaders.'X-WP-Total' -and ($result.count -ne [int]($responseHeaders.'X-WP-Total' | Out-String))) {
                Write-Warning -Message "Not all $($responseHeaders.'X-WP-Total') items could be retrieved. Count: $($result.count) (maybe a filter is set)"
                Wait-Debugger
            }
            return $result
        }
        else {
            return $null
        }
    }
    catch {
        Write-Error -Message $_.Exception.Message -Category InvalidOperation
        Write-Error -Message $_.tostring() -Category InvalidOperation
        Wait-Debugger
        return $null
    }
}
