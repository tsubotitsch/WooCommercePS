function Get-WooCommerceCategory {
    <#
    .SYNOPSIS
        Retrieve product categories

    .DESCRIPTION
        This API lets you retrieve and view a list of all product categories, or retrieve a specific category.

    .PARAMETER id
        Unique identifier for the category. If not set, all categories will be returned.

    .PARAMETER addquery
        Additional query string to append to the API request.

    .EXAMPLE
        PS C:\> Get-WooCommerceCategory

        Retrieves all product categories.

    .EXAMPLE
        PS C:\> Get-WooCommerceCategory -id 123

        Retrieves the specific category with ID 123.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-product-categories
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Position = 1, HelpMessage = "The id of the category, if not set, all categories will be returned")]
        [ValidateNotNullOrEmpty()]
        [System.String]$id,
        [string]$addquery
    )
    if (Get-WooCommerceCredential) {
        $url = "/products/categories"
        if ($id) {
            $url += "/$id"
        }

        if ($addquery) {
            $url += $addquery
        }
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
}
