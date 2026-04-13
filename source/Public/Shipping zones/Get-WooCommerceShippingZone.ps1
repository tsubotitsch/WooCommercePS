function Get-WooCommerceShippingZone {
    <#
    .SYNOPSIS
        Retrieve shipping zones

    .DESCRIPTION
        This API lets you retrieve and view a list of all shipping zones, or a single shipping zone.

    .PARAMETER id
        Unique identifier for the resource.

    .EXAMPLE
        Get-WooCommerceShippingZone

    .NOTES
        Requires valid WooCommerce credentials.
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Position = 1)]
        [System.String]$id
    )

    if (Get-WooCommerceCredential) {
        $url = "/shipping/zones"
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
