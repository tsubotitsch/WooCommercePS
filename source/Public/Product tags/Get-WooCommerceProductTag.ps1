function Get-WooCommerceProductTag {
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [System.String]$id,
        [Parameter(Position = 2)]
        [switch]$all
    )

    if (Get-WooCommerceCredential) {
        $url = "/products/tags"
        if ($id -and !$all) {
            $url += "/$id"
        }
        #$result = Invoke-RestMethod -Method GET -Uri "$url" -Headers $script:woocommerceBase64AuthInfo -ResponseHeadersVariable responseHeaders
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
}

