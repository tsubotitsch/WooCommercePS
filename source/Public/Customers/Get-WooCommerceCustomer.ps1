function Get-WooCommerceCustomer {
<#
    .SYNOPSIS
        Retrieve customers

    .DESCRIPTION
        This API lets you retrieve and view a list of all customers, or a single customer.

    .PARAMETER id
        Unique identifier for the resource.

    .PARAMETER role
        Limit result set to resources with a specific role. Options: all, administrator, editor, author, contributor, subscriber, customer and shop_manager. Default is customer.

    .PARAMETER orderby
        Sort collection by object attribute. Options: id, include, name and registered_date. Default is id.

    .PARAMETER order
        Order sort attribute ascending or descending. Options: asc and desc. Default is asc.

    .EXAMPLE
        Get-WooCommerceCustomer -id 123

    .EXAMPLE
        Get-WooCommerceCustomer -role administrator

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).
#>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [System.String]$id,
        [Parameter(Position = 2, HelpMessage = "Limit result set to resources with a specific role. Options: all, administrator, editor, author, contributor, subscriber, customer and shop_manager. Default is customer.")]
        [ValidateSet("all", "administrator", "editor", "author", "contributor", "subscriber", "customer", "shop_manager")]
        $role = 'customer',
        [Parameter(Position = 3)]
        [ValidateSet("id", "include", "name", "registered_date")]
        $orderby = 'id',
        [Parameter(Position = 4)]
        [ValidateSet("asc", "desc")]
        $order = 'asc'
    )

    if (Get-WooCommerceCredential) {
        $url = "/customers"
        if ($id) {
            $url += "/$id"
        }
        else {
            Write-Debug "Role: $role OrderBy: $orderby"
            $url += "?role=$($role)&orderby=$($orderby)&order=$($order)"
        }
        Write-Debug "GET $url"
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
 else {
        return $null
    }
}
