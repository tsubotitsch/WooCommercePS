function Get-WooCommerceData
{
    <#
    .SYNOPSIS
        Retrieve WooCommerce data/information

    .DESCRIPTION
        This API lets you retrieve and view arbitrary data or information from your WooCommerce store.
        The Data endpoint provides access to system information, configuration data, and other store-level
        information that is not categorized under specific resources like products, orders, or customers.

    .EXAMPLE
        PS C:\> Get-WooCommerceData

        Retrieves all available data/information from the WooCommerce store.

    .NOTES
        Requires valid WooCommerce credentials set via Set-WooCommerceCredential.

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#data
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
    )

    if (Get-WooCommerceCredential)
    {
        $url = "/data"
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
    else
    {
        return $null
    }
}
