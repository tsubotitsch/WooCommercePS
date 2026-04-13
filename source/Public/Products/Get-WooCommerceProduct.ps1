function Get-WooCommerceProduct {
    <#
    .SYNOPSIS
        Retrieve WooCommerce products

    .DESCRIPTION
        This API lets you retrieve and view a list of all products, or retrieve a specific product.
        You can filter products by various criteria such as SKU, category, tag, and stock status.

    .PARAMETER id
        Unique identifier for the product.

    .PARAMETER category
        Limit results to products assigned to a specific category ID.

    .PARAMETER tag
        Limit results to products assigned to a specific tag ID.

    .PARAMETER sku
        Limit results to products with a specific SKU.

    .PARAMETER stockstatus
        Limit results to products with a specific stock status.
        Options: instock, outofstock, onbackorder. Default is instock.

    .PARAMETER on_sale
        Limit results to products on sale.

    .PARAMETER tax_class
        Limit results to products with a specific tax class.
        Options: reduced-rate, zero-rate, standard. Default is standard.

    .PARAMETER orderby
        Sort products by attribute. Options: id, include, title, slug, date. Default is date.

    .PARAMETER order
        Sort order direction. Options: asc, desc. Default is asc.

    .EXAMPLE
        PS C:\> Get-WooCommerceProduct

        Retrieves all in-stock products sorted by date.

    .EXAMPLE
        PS C:\> Get-WooCommerceProduct -id 123

        Retrieves the specific product with ID 123.

    .EXAMPLE
        PS C:\> Get-WooCommerceProduct -category 5 -on_sale 'true'

        Retrieves all on-sale products from category 5.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-products
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        $id,
        [Parameter()]
        [string]$addquery,
        [Parameter(HelpMessage = "Sort products ascending or descending. Options: asc, desc. Default is asc.")]
        [ValidateSet('asc', 'desc')]
        $order = 'asc',
        [Parameter(HelpMessage = "Sort products by attribute. Options: id, include, title, slug, date. Default is date.")]
        [ValidateSet('id', 'include', 'title', 'slug', 'date')]
        $orderby = 'date',
        [Parameter(HelpMessage = "Limit result set to products with a specific SKU.")]
        $sku,
        [Parameter(HelpMessage = "Limit result set to products assigned to a specific category_id.")]
        $category,
        [Parameter(HelpMessage = "Limit result set to products assigned to a specific tag.")]
        $tag,
        [Parameter(HelpMessage = "Limit result set to products with a specific stock status. Options: instock, outofstock, onbackorder. Default is instock.")]
        [ValidateSet('instock', 'outofstock', 'onbackorder')]
        $stockstatus = 'instock',
        [Parameter(HelpMessage = "Limit result set to products on sale.")]
        $on_sale,
        [Parameter(HelpMessage = "Limit result set to products with a specific tax class. Options: reduced-rate, zero-rate, standard. Default is standard.")]
        [ValidateSet('reduced-rate', 'zero-rate', 'standard')]
        $tax_class = 'standard',
        [Parameter(HelpMessage = "Limit result set to specific ids.")]
        $include,
        [Parameter(HelpMessage = "Limit result set to products assigned a specific type. Options: simple, grouped, external and variable.")]
        [ValidateSet("simple", "grouped", "external", "variable")]
        $type,
        [Parameter(HelpMessage = "Return products with variations when specified (switch).")]
        [switch]$variations
    )
    if (Get-WooCommerceCredential) {
        $url = "/products"
        if ($id) {
            if ($id -is [array]) {
                $idList = $id -join ','
                $url += "?include=$idList"
                $url += "&orderby=$orderby&order=$order&stock_status=$stockstatus"
            }
            else {
                $url += "/$id"
            }
        }
        else {
            $url += "?orderby=$orderby&order=$order&stock_status=$stockstatus"
            if ($sku) {
                $url += "&sku=$sku"
            }
            if ($category) {
                $url += "&category=$category"
            }
            if ($tag) {
                $url += "&tag=$tag"
            }
            if ($addquery) {
                $url += $addquery
            }
            if ($on_sale) {
                $url += "&on_sale=$on_sale"
            }
            if ($tax_class -ne 'standard') {
                $url += "&tax_class=$tax_class"
            }
            if ($include) {
                $url += "&include=$include"
            }
            if ($type) {
                $url += "&type=$type"
            }
        }
        Write-Debug -Message "GET $url"
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        if ($variations -and $result) {
            write-debug "Get variations for product(s) ..."
            $variationResults = @()
            foreach ($product in @($result)) {
                if (([int]$product.parent_id -eq 0) -and ($product.type -eq 'variable') -and ($product.variations.count -gt 0)) {
                    $variationResults += Get-WooCommerceProductVariation -ParentProductId $product.id
                }
            }
            # Ensure $result is an array before concatenation
            $result = @($result) + $variationResults | sort-object id
        }
        return $result
    }
}
