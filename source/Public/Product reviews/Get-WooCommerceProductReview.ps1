function Get-WooCommerceProductReview {
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Position = 1, HelpMessage = "The id of the product")]
        [ValidateNotNullOrEmpty()]
        [System.String]$ProductId
    )
    if (Get-WooCommerceCredential) {
        $url = "/products/reviews"
        if ($id) {
            $url += "/$id"
        }
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
}

