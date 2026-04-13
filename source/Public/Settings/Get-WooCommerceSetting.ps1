function Get-WooCommerceSetting {
    <#
    .SYNOPSIS
        Retrieve settings

    .DESCRIPTION
        This API lets you retrieve and view a list of all available settings groups in WooCommerce.

    .EXAMPLE
        PS C:\> Get-WooCommerceSetting

        Retrieves all available settings groups.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-settings
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
    )

    if (Get-WooCommerceCredential) {
        $url = "/settings"
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
    else {
        return $null
    }
}
