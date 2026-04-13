function Get-WooCommerceReport {
    <#
    .SYNOPSIS
        Retrieve a specific report

    .DESCRIPTION
        This API lets you retrieve data from a specific WooCommerce report.

    .PARAMETER type
        The type of report to retrieve.

    .EXAMPLE
        PS C:\> Get-WooCommerceReport -type sales

        Retrieves the sales report data.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#retrieve-a-report
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param (
        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The name/slug of the report to retrieve .e.g. sales, top_sellers, categories/totals, coupons/totals, customers/totals, orders/totals, products/totals, reviews/totals, tags/totals, attributes/totals")]
        [alias("ReportName", "Slug")]
        [string] $Name
    )
    $result = Invoke-WooCommerceAPICall -RelativeUrl "/reports/$Name" -Method "GET"
    return $result
}
