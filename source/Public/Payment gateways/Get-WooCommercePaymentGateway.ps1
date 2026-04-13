function Get-WooCommercePaymentGateway {
    <#
    .SYNOPSIS
        Retrieve payment gateways

    .DESCRIPTION
        This API lets you retrieve and view a list of all payment gateways, or retrieve a specific payment gateway.

    .PARAMETER id
        Unique identifier for the payment gateway (e.g., 'cod' for Cash on Delivery, 'bacs' for Bank Transfer).

    .EXAMPLE
        PS C:\> Get-WooCommercePaymentGateway

        Retrieves all payment gateways.

    .EXAMPLE
        PS C:\> Get-WooCommercePaymentGateway -id cod

        Retrieves the Cash on Delivery payment gateway.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-payment-gateways
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Position = 1)]
        [System.String]$id
    )

    if (Get-WooCommerceCredential) {
        $url = "/payment_gateways"
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
