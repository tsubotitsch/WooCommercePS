function Get-WooCommerceOrder
{
    <#
    .SYNOPSIS
        Retrieve WooCommerce orders

    .DESCRIPTION
        This API lets you retrieve and view a list of all orders, or retrieve a specific order.
        You can filter orders by various criteria such as status, customer, date range, and product.
        Results can be sorted and paginated for efficient data retrieval.

    .PARAMETER id
        Unique identifier for the order. If provided, only that specific order will be retrieved.
        If omitted, all orders matching the filter criteria will be retrieved.

    .PARAMETER Status
        Limit results to orders with a specific status. Valid options are:
        - any: All orders (default)
        - pending: Orders awaiting payment
        - processing: Orders that have been paid
        - on-hold: Orders on hold
        - completed: Completed orders
        - cancelled: Cancelled orders
        - refunded: Refunded orders
        - failed: Failed orders
        - trash: Trashed orders
        Default value is 'any'.

    .PARAMETER customer_id
        Limit results to orders from a specific customer by customer ID.
        Use 0 to retrieve orders from all customers (default).

    .PARAMETER orderby
        Sort collection by object attribute. Valid options are:
        - id: Sort by order ID
        - include: Sort by included order IDs
        - title: Sort by order title
        - slug: Sort by order slug
        - date: Sort by order date (default)

    .PARAMETER order
        Sort order direction. Valid options are:
        - asc: Ascending order (default)
        - desc: Descending order

    .PARAMETER before
        Limit response to orders created before a given ISO8601 compliant date.
        Example: '2024-12-31' or '2024-12-31T23:59:59'

    .PARAMETER after
        Limit response to orders created after a given ISO8601 compliant date.
        Example: '2024-01-01' or '2024-01-01T00:00:00'

    .PARAMETER product
        Limit results to orders containing a specific product by product ID.

    .PARAMETER addquery
        Additional query string to append to the API request for advanced filtering.
        Example: '&per_page=50&page=2'

    .EXAMPLE
        PS C:\> Get-WooCommerceOrder

        Retrieves all orders with default filters (status=any, sorted by date ascending).

    .EXAMPLE
        PS C:\> Get-WooCommerceOrder -id 123

        Retrieves the specific order with ID 123.

    .EXAMPLE
        PS C:\> Get-WooCommerceOrder -Status completed -orderby date -order desc

        Retrieves all completed orders sorted by date in descending order (newest first).

    .EXAMPLE
        PS C:\> Get-WooCommerceOrder -customer_id 42 -Status processing

        Retrieves all processing orders from customer with ID 42.

    .EXAMPLE
        PS C:\> Get-WooCommerceOrder -after '2024-01-01' -before '2024-12-31' -product 10

        Retrieves all orders from 2024 that contain product with ID 10.

    .EXAMPLE
        PS C:\> Get-WooCommerceOrder -Status pending | Select-Object -Property id, total, billing

        Retrieves all pending orders and displays ID, total, and billing information.

    .NOTES
        Requires valid WooCommerce credentials set via Set-WooCommerceCredential.
        Date parameters accept various formats but ISO8601 format is recommended.
        The function automatically handles date formatting when -before or -after parameters are used.
        Results are paginated by default; use -addquery parameter to adjust page size and page number.

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-orders
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [System.String]$id,
        [Parameter(Position = 2, HelpMessage = "Limit result set to orders assigned a specific status. Options: any, pending, processing, on-hold, completed, cancelled, refunded, failed and trash. Default is any." )]
        [ValidateSet('any', 'pending', 'processing', 'on-hold', 'completed', 'cancelled', 'refunded', 'failed', 'trash')]
        [string]$Status = 'any',
        [Parameter(Position = 3, HelpMessage = "Limit result set to orders assigned a specific customer_id. Default is 0.")]
        $customer_id = "0",
        [Parameter()]
        [string]$addquery,
        [Parameter(HelpMessage = "Limit response to resources published before a given ISO8601 compliant date.")]
        $before,
        [Parameter(HelpMessage = "Limit response to resources published after a given ISO8601 compliant date.")]
        $after,
        [Parameter(HelpMessage = "Order sort attribute ascending or descending. Options: asc, desc. Default is asc.")]
        [ValidateSet('asc', 'desc')]
        $order = 'asc',
        [Parameter(HelpMessage = "Sort collection by object attribute. Options: id, include, title, slug, date. Default is date.")]
        [ValidateSet('id', 'include', 'title', 'slug', 'date')]
        $orderby = 'date',
        [Parameter(HelpMessage = "Limit result set to orders assigned a specific product.")]
        [int]$product
    )

    if (Get-WooCommerceCredential)
    {
        $url = "/orders"
        if ($id)
        {
            $url += "/$id"
        }
        else
        {
            $url += "?status=$Status&customer_id=$customer_id&orderby=$orderby&order=$order"
            if ($before)
            {
                $before_date = Get-Date $before -Format "yyyy-MM-ddTHH:mm:ss"
                $url += "&before=$before_date"
            }
            if ($after)
            {
                $after_date = Get-Date $after -Format "yyyy-MM-ddTHH:mm:ss"
                $url += "&after=$after_date"
            }
            if ($product)
            {
                $url += "&product=$product"
            }
        }
        if ($addquery)
        {
            $url += $addquery
        }
        #$result = Invoke-RestMethod -Method GET -Uri "$url" -Headers $script:woocommerceBase64AuthInfo
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
}
