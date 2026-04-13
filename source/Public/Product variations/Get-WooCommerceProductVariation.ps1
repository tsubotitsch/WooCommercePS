function Get-WooCommerceProductVariation {
    <#
    .SYNOPSIS
        Retrieve product variations

    .DESCRIPTION
        This API lets you retrieve and view a list of all variations for a variable product,
        or retrieve a specific product variation.

    .PARAMETER ParentProductId
        Unique identifier for the parent variable product.

    .PARAMETER VariationId
        Unique identifier for a specific product variation.

    .PARAMETER sku
        Limit results to variations with a specific SKU.

    .PARAMETER slug
        Limit results to variations with a specific slug.

    .PARAMETER on_sale
        Limit results to variations on sale.

    .PARAMETER stock_status
        Limit results to variations with a specific stock status.
        Options: instock, outofstock, onbackorder.

    .PARAMETER orderby
        Sort variations by attribute. Options: id, include, title, slug, date. Default is date.

    .PARAMETER order
        Sort order direction. Options: asc, desc. Default is asc.

    .EXAMPLE
        PS C:\> Get-WooCommerceProductVariation -ParentProductId 123

        Retrieves all variations for product with ID 123.

    .EXAMPLE
        PS C:\> Get-WooCommerceProductVariation -ParentProductId 123 -VariationId 456

        Retrieves a specific variation from a product.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-product-variations
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Position = 1, HelpMessage = "The id of the parent product")]
        [ValidateNotNullOrEmpty()]
        [System.String]$ParentProductId,
        [Parameter(Position = 2, HelpMessage = "The id of the variation")]
        [string]$VariationId,
        $order = 'asc',
        [Parameter(HelpMessage = "Sort productvariants by attribute. Options: id, include, title, slug, date. Default is date.")]
        [ValidateSet('id', 'include', 'title', 'slug', 'date')]
        $orderby = 'date',
        [Parameter(HelpMessage = "Limit result set to product variants with a specific SKU.")]
        $sku,
        [Parameter(HelpMessage = "Limit result set to product variants with a specific slug.")]
        $slug,
        [Parameter(HelpMessage = "Limit result set to product variants on sale.")]
        $on_sale,
        [Parameter(HelpMessage = "Limit result set to product variants with a specific stock status. Options: instock, outofstock, onbackorder.")]
        [ValidateSet('instock', 'outofstock', 'onbackorder')]
        $stock_status
    )
    if (Get-WooCommerceCredential) {
        if (-not $ParentProductId) {
            $ParentProductId = Get-WooCommerceProduct -id $VariationId | select-object -ExpandProperty parent_id
        }
        $url = "/products/$ParentProductId/variations"
        if ($VariationId) {
            $url += "/$VariationId"
        }
        else {
            $url += "?orderby=$orderby&order=$order"
            if ($sku) {
                $url += "&sku=$sku"
            }
            if ($slug) {
                $url += "&slug=$slug"
            }
            if ($on_sale) {
                $url += "&on_sale=$on_sale"
            }
            if ($stock_status) {
                $url += "&stock_status=$stock_status"
            }
        }
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
}
