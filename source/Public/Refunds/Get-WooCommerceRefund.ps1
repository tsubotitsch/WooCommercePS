function Get-WooCommerceRefund {
    <#
    .SYNOPSIS
        Retrieve refunds

    .DESCRIPTION
        This API lets you retrieve and view a list of all refunds, or retrieve a specific refund.

    .PARAMETER id
        Unique identifier for the refund.

    .EXAMPLE
        PS C:\> Get-WooCommerceRefund

        Retrieves all refunds.

    .EXAMPLE
        PS C:\> Get-WooCommerceRefund -id 123

        Retrieves the specific refund with ID 123.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-refunds
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Position = 1)]
        [System.String]$addquery
    )

    if (Get-WooCommerceCredential) {
        $url = "/customers"
        if ($addquery) {
            $url += "/$addquery"
        }
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
    else {
        return $null
    }
}
