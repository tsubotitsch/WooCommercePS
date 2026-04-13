function Get-WooCommerceShippingMethod {
    <#
    .SYNOPSIS
        Retrieve shipping methods

    .DESCRIPTION
        This API lets you retrieve and view a list of all shipping methods available in WooCommerce.

    .PARAMETER id
        Unique identifier for the shipping method.

    .EXAMPLE
        PS C:\> Get-WooCommerceShippingMethod

        Retrieves all available shipping methods.

    .EXAMPLE
        PS C:\> Get-WooCommerceShippingMethod -id flat_rate

        Retrieves the flat rate shipping method.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-shipping-methods
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Position = 1)]
        [System.String]$id
    )

    if (Get-WooCommerceCredential) {
        $url = "/shipping_methods"
        if ($id) {
            $url += "/$id"
        }
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
    else {
        return $null
    }
}
