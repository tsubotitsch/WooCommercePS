function Get-WooCommerceShippingZoneMethod {
    <#
    .SYNOPSIS
        Retrieve shipping zone methods

    .DESCRIPTION
        This API lets you retrieve and view all shipping methods assigned to a shipping zone.

    .PARAMETER id
        Unique identifier for the shipping zone.

    .EXAMPLE
        PS C:\> Get-WooCommerceShippingZoneMethod -id 1

        Retrieves all shipping methods for zone with ID 1.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-shipping-zone-methods
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Mandatory = $true, Position = 1)]
        [System.String]$id
    )

    if (Get-WooCommerceCredential) {
        $url = "/shipping/zones/$id/methods"
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
    else {
        return $null
    }
}
