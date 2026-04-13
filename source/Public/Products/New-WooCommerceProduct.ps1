function New-WooCommerceProduct {
    <#
    .SYNOPSIS
        Create a new WooCommerce product

    .DESCRIPTION
        This API lets you create a new product in WooCommerce with the specified properties.

    .PARAMETER name
        Product name (required).

    .PARAMETER type
        Product type. Options: external, grouped, simple, variable. Default is simple.

    .PARAMETER description
        Product description.

    .PARAMETER short_description
        Product short description.

    .PARAMETER status
        Product status. Options: draft, pending, private, publish. Default is publish.

    .PARAMETER slug
        Product slug for the URL.

    .PARAMETER featured
        Mark product as featured. Options: 'true', 'false'. Default is 'false'.

    .PARAMETER catalog_visibility
        Catalog visibility. Options: visible, catalog, search, hidden. Default is visible.

    .PARAMETER sku
        Product SKU (Stock Keeping Unit).

    .PARAMETER regular_price
        Regular price of the product.

    .PARAMETER sale_price
        Sale price of the product.

    .PARAMETER date_on_sale_from
        Date when the sale starts.

    .PARAMETER date_on_sale_to
        Date when the sale ends.

    .PARAMETER virtual
        Whether the product is virtual. Options: 'true', 'false'. Default is 'false'.

    .PARAMETER downloadable
        Whether the product is downloadable. Options: 'true', 'false'. Default is 'false'.

    .EXAMPLE
        PS C:\> New-WooCommerceProduct -name 'Test Product' -regular_price 9.99

        Creates a new simple product with a regular price of 9.99.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).
        Requires -WhatIf parameter support.

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#create-a-product
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([PSObject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$name,
        [ValidateSet('external', 'grouped', 'simple', 'variable')]
        [ValidateNotNullOrEmpty()]
        [System.String]$type = 'simple',
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$description,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$short_description,
        [ValidateSet('draft', 'pending', 'private', 'publish')]
        [ValidateNotNullOrEmpty()]
        [System.String]$status = 'publish',
        [ValidateNotNullOrEmpty()]
        [System.String]$slug,
        [ValidateSet('false', 'true')]
        [ValidateNotNullOrEmpty()]
        [System.String]$featured = 'false',
        [ValidateSet('visible', 'catalog', 'search', 'hidden')]
        [ValidateNotNullOrEmpty()]
        [System.String]$catalog_visibility = 'visible',
        [ValidateNotNullOrEmpty()]
        [System.String]$sku,
        [ValidateNotNullOrEmpty()]
        [double]$regular_price,
        [ValidateNotNullOrEmpty()]
        [double]$sale_price,
        [ValidateNotNullOrEmpty()]
        [datetime]$date_on_sale_from,
        [ValidateNotNullOrEmpty()]
        [datetime]$date_on_sale_to,
        [ValidateSet('false', 'true')]
        [ValidateNotNullOrEmpty()]
        [System.String]$virtual = 'false',
        [ValidateSet('false', 'true')]
        [ValidateNotNullOrEmpty()]
        [System.String]$downloadable = 'false'
    )

    $filterParameter = @(
	"Verbose",
	"Debug",
	"ErrorAction",
	"WarningAction",
	"InformationAction",
	"ErrorVariable",
	"WarningVariable",
	"InformationVariable",
	"OutVariable",
	"OutBuffer",
	"PipelineVariable",
	"WhatIf",
	"Confirm"
)
    if ($PSCmdlet.ShouldProcess("Create a new product")) {
        if (Get-WooCommerceCredential) {
            $query = @{
            }
            $url = "$script:woocommerceUrl/$script:woocommerceProducts"

            $CommandName = $PSCmdlet.MyInvocation.InvocationName
            $ParameterList = (Get-Command -Name $CommandName).Parameters.Keys | Where-Object {
                $_ -notin $filterParameter
            }

            foreach ($Parameter in $ParameterList) {
                $var = Get-Variable -Name $Parameter -ErrorAction SilentlyContinue
                if ($var.Value -match "\d|\w") {
                    $value = $var.Value
                    if ($var.Name -in @("date_on_sale_from", "date_on_sale_to")) {
                        $value = Get-Date $value -Format s
                    }
                    $query += @{
                        $var.Name = "$value"
                    }
                }
            }
            $json = $query | ConvertTo-Json
            $result = Invoke-RestMethod -Method POST -Uri "$url" -Headers $script:woocommerceBase64AuthInfo -Body $json -ContentType 'application/json'
            if ($result) {
                return $result
            }
        }
    }
}
