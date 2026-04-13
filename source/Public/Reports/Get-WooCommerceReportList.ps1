function Get-WooCommerceReportList {
    <#
    .SYNOPSIS
        Retrieve available reports

    .DESCRIPTION
        This API lets you retrieve a list of all available reports in WooCommerce.

    .EXAMPLE
        PS C:\> Get-WooCommerceReportList

        Retrieves the list of all available report types.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-reports
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param ()
    $result = Invoke-WooCommerceAPICall -RelativeUrl "/reports" -Method "GET"
    return $result
}
