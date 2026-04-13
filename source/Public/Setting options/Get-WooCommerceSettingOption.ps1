function Get-WooCommerceSettingOption {
    <#
    .SYNOPSIS
        Retrieve a setting option

    .DESCRIPTION
        This API lets you retrieve a specific setting option from a settings group.

    .PARAMETER group
        The settings group (e.g., general, products, tax).

    .PARAMETER id
        The setting option ID.

    .EXAMPLE
        PS C:\> Get-WooCommerceSettingOption -group general -id woocommerce_currency

        Retrieves the currency setting from the general group.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#retrieve-a-setting-option
    #>
    [CmdletBinding()]
    [OutputType([PSObject])]
    param
    (
        [Parameter(Mandatory = $true, Position = 1)]
        [System.String]$group_id,
        [Parameter(Mandatory = $true, Position = 2)]
        $id
    )

    if (Get-WooCommerceCredential) {
        $url = "/settings/$group_id/$id"
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
    else {
        return $null
    }
}
