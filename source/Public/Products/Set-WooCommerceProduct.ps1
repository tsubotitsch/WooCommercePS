function Set-WooCommerceProduct {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([PSObject])]
    param
    (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "The ID of the product to modify.")]
        [ValidateNotNullOrEmpty()]
        [System.String]$id,

        [Parameter(HelpMessage = "Product type: external, grouped, simple, variable.")]
        [ValidateSet('external', 'grouped', 'simple', 'variable')]
        [System.String]$type,

        [Parameter(HelpMessage = "Product status: draft, pending, private or publish.")]
        [ValidateSet('draft', 'pending', 'private', 'publish')]
        [System.String]$status,

        [Parameter(HelpMessage = "Mark the product as featured (True/False).")]
        [bool]$featured,

        [Parameter(HelpMessage = "Catalog visibility: visible, catalog, search, hidden.")]
        [ValidateSet('visible', 'catalog', 'search', 'hidden')]
        [System.String]$catalog_visibility,

        [Parameter(HelpMessage = "Product name.")]
        [System.String]$name,

        [Parameter(HelpMessage = "Product URL slug.")]
        [System.String]$slug,

        [Parameter(HelpMessage = "Full product description.")]
        [System.String]$description,

        [Parameter(HelpMessage = "Short product description.")]
        [System.String]$short_description,

        [Parameter(HelpMessage = "Stock Keeping Unit (SKU).")]
        [System.String]$sku,

        [Parameter(HelpMessage = "Regular price as string (e.g. '9.99').")]
        [System.String]$regular_price,

        [Parameter(HelpMessage = "Sale price as string (e.g. '7.99').")]
        [System.String]$sale_price,

        [Parameter(HelpMessage = "Start date of sale (ISO/DateTime).")]
        [datetime]$date_on_sale_from,

        [Parameter(HelpMessage = "End date of sale (ISO/DateTime).")]
        [datetime]$date_on_sale_to,

        [Parameter(HelpMessage = "Virtual product (True/False).")]
        [bool]$virtual,

        [Parameter(HelpMessage = "Downloadable product (True/False).")]
        [bool]$downloadable,

        [Parameter(HelpMessage = "List of downloads (array of objects with 'name'/'file').")]
        [object[]]$downloads,

        [Parameter(HelpMessage = "Maximum number of downloads (integer).")]
        [int]$download_limit,

        [Parameter(HelpMessage = "Download expiry in days (integer).")]
        [int]$download_expiry,

        [Parameter(HelpMessage = "External URL (for external products).")]
        [System.String]$external_url,

        [Parameter(HelpMessage = "Button text for external products.")]
        [System.String]$button_text,

        [Parameter(HelpMessage = "Tax status (e.g. 'taxable', 'shipping', 'none').")]
        [System.String]$tax_status,

        [Parameter(HelpMessage = "Tax class (e.g. 'standard').")]
        [System.String]$tax_class,

        [Parameter(HelpMessage = "Enable stock management (True/False).")]
        [bool]$manage_stock,

        [Parameter(HelpMessage = "Stock quantity (integer).")]
        [int]$stock_quantity,

        [Parameter(HelpMessage = "Stock status: instock, outofstock, onbackorder.")]
        [ValidateSet('instock', 'outofstock', 'onbackorder')]
        [System.String]$stock_status,

        [Parameter(HelpMessage = "Allow backorders: no, notify, yes.")]
        [ValidateSet('no', 'notify', 'yes')]
        [System.String]$backorders,

        [Parameter(HelpMessage = "Sold individually only (True/False).")]
        [bool]$sold_individually,

        [Parameter(HelpMessage = "Weight as string (e.g. '0.5').")]
        [System.String]$weight,

        [Parameter(HelpMessage = "Dimensions as hashtable with keys 'length','width','height'.")]
        [hashtable]$dimensions,

        [Parameter(HelpMessage = "Shipping class ID (integer).")]
        [int]$shipping_class_id,

        [Parameter(HelpMessage = "Allow reviews (True/False).")]
        [bool]$reviews_allowed,

        [Parameter(HelpMessage = "Purchase note to send after purchase.")]
        [System.String]$purchase_note,

        [Parameter(HelpMessage = "Categories as array of hashtables or objects (e.g. @{id=123}).")]
        [object[]]$categories,

        [Parameter(HelpMessage = "Tags as array of hashtables or objects (e.g. @{id=5}).")]
        [object[]]$tags,

        [Parameter(HelpMessage = "Images as array of hashtables (e.g. @{src='url'; position=0}).")]
        [object[]]$images,

        [Parameter(HelpMessage = "Product attributes as array of hashtables (e.g. @{id=1; name='Color'; options=@('red')}).")]
        [object[]]$attributes,

        [Parameter(HelpMessage = "Default attributes for variations as array of hashtables.")]
        [object[]]$default_attributes,

        [Parameter(HelpMessage = "Grouped products as array of IDs.")]
        [int[]]$grouped_products,

        [Parameter(HelpMessage = "Related product IDs as array.")]
        [int[]]$related_ids,

        [Parameter(HelpMessage = "Upsell product IDs as array.")]
        [int[]]$upsell_ids,

        [Parameter(HelpMessage = "Cross-sell product IDs as array.")]
        [int[]]$cross_sell_ids,

        [Parameter(HelpMessage = "Menu order (integer).")]
        [int]$menu_order,

        [Parameter(HelpMessage = "Meta data as array of hashtables (e.g. @{key='foo'; value='bar'}).")]
        [object[]]$meta_data,

        [Parameter(HelpMessage = "Fallback: hashtable with additional writable product properties.")]
        [hashtable]$Properties
    )
    $Product =  Get-WooCommerceProduct -id $id
    if ( [int]$Product.parent_id -eq 0 ) {
        $url = "/products/$id"
    } else {
        $url = "/products/$($Product.parent_id)/variations/$id"
    }

    if ($pscmdlet.ShouldProcess("Modify product $id")) {
        if (Get-WooCommerceCredential) {
            $query = @{ }

            # Only include parameters that were explicitly provided on the command line
            foreach ($kv in $PSBoundParameters.GetEnumerator()) {
                if ($kv.Key -in @('id','Properties')) { continue }
                $value = $kv.Value
                if ($value -is [datetime]) {
                    $value = Get-Date $value -Format s
                }
                $query[$kv.Key] = $value
            }

            # Merge additional properties provided via -Properties, filtering read-only fields
            if ($PSBoundParameters.ContainsKey('Properties') -and $Properties) {
                $readonlyFields = @(
                    'id', 'date_created', 'date_created_gmt', 'date_modified', 'date_modified_gmt',
                    'permalink', 'average_rating', 'rating_count', 'total_sales', '_links'
                )
                foreach ($key in $Properties.Keys) {
                    if ($key -in $readonlyFields) {
                        Write-Verbose "Skipping read-only field: $key"
                        continue
                    }
                    $query[$key] = $Properties[$key]
                }
            }
            if ($query.Count -gt 0) {
                $json = $query | ConvertTo-Json
                $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "PUT" -Body $json
                return $result
            }
            else {
                Write-Error -Message "No value provided" -Category InvalidData
            }
        }
    }
}

