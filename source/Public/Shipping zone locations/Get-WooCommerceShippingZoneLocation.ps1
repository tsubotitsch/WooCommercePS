function Get-WooCommerceShippingZoneLocation {
    <#
    .SYNOPSIS
        Retrieve shipping zone locations

    .DESCRIPTION
        This API lets you retrieve and view all locations assigned to a shipping zone.

    .PARAMETER id
        Unique identifier for the shipping zone.

    .EXAMPLE
        PS C:\> Get-WooCommerceShippingZoneLocation -id 1

        Retrieves all locations for shipping zone with ID 1.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-shipping-zone-locations
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Mandatory = $true, Position = 1)]
        [System.String]$id
    )

    if (Get-WooCommerceCredential) {
        $url = "/shipping/zones/$id/locations"
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
    else {
        return $null
    }
}
