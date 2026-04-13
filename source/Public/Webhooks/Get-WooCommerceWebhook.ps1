function Get-WooCommerceWebhook {
    <#
    .SYNOPSIS
        Retrieve WooCommerce webhooks

    .DESCRIPTION
        This API lets you retrieve and view a list of all webhooks, or retrieve a specific webhook.
        Webhooks allow you to send data automatically when certain events occur in your WooCommerce store.

    .PARAMETER id
        Unique identifier for the webhook.

    .PARAMETER status
        Limit results to webhooks with a specific status.
        Options: all, active, inactive, paused, disabled. Default is all.

    .PARAMETER addquery
        Additional query string to append to the API request.

    .EXAMPLE
        PS C:\> Get-WooCommerceWebhook

        Retrieves all webhooks with all statuses.

    .EXAMPLE
        PS C:\> Get-WooCommerceWebhook -id 123

        Retrieves the specific webhook with ID 123.

    .EXAMPLE
        PS C:\> Get-WooCommerceWebhook -status active

        Retrieves all active webhooks.

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-webhooks
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Position = 1)]
        $id,
        [Parameter(Position = 2, HelpMessage = "Limit result set to resources with a specific status. Options: all, active, inactive, paused, disabled. Default is all.")]
        [ValidateSet("all", "active", "inactive", "paused", "disabled")]
        $status = "all",
        [System.String]$addquery
    )

    if (Get-WooCommerceCredential) {
        $url = "/webhooks"
        if ($id) {
            $url += "/$id"
        }
        else {
            $url += "?status=$status"
        }
        if ($addquery) {
            $url += "/$addquery"
        }
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
    else {
        return $null
    }
}
