function Get-WooCommerceProductCustomFields {
    <#
    .SYNOPSIS
        Retrieve product custom fields

    .DESCRIPTION
        This API lets you retrieve custom fields associated with products in WooCommerce.

    .EXAMPLE
        PS C:\> Get-WooCommerceProductCustomFields

        Retrieves all product custom field definitions.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param()
    if (Get-WooCommerceCredential) {
        $url = "/products/custom-fields/names"
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
}
