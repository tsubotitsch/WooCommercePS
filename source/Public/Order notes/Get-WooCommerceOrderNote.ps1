function Get-WooCommerceOrderNote {
    <#
    .SYNOPSIS
        Retrieve WooCommerce order notes

    .DESCRIPTION
        This API lets you retrieve and view a list of all notes added to an order, or retrieve a single
        order note. Order notes are private internal notes or customer messages attached to an order.

    .PARAMETER id
        Unique identifier for the order. This parameter is mandatory and specifies which order's notes
        to retrieve. Accepts 'OrderId' as an alias.

    .PARAMETER NoteId
        Unique identifier for a specific order note. If provided, only that particular note will be
        retrieved. If omitted, all notes for the order are retrieved.

    .EXAMPLE
        PS C:\> Get-WooCommerceOrderNote -id 123

        Retrieves all notes associated with order ID 123.

    .EXAMPLE
        PS C:\> Get-WooCommerceOrderNote -OrderId 123 -NoteId 456

        Retrieves the specific note with ID 456 from order 123. Note that 'OrderId' is an alias for the -id parameter.

    .EXAMPLE
        PS C:\> Get-WooCommerceOrderNote -id 123 | Select-Object -Property author, note

        Retrieves all notes for order 123 and displays the author and note content for each.

    .NOTES
        Requires valid WooCommerce credentials set via Set-WooCommerceCredential.
        Order notes can include customer-facing notes or internal-only notes depending on the note type.

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#list-all-order-notes
    #>
    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param
    (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "The id of the order")]
        [Alias("OrderId")]
        [System.String]$id,
        [Parameter(Position = 2, HelpMessage = "The id of the note")]
        [string]$NoteId
    )

    if (Get-WooCommerceCredential) {
        $url = "/orders/$id/notes"
        if ($id -and !$all) {
            $url += "/$id"
        }
        if ($NoteId) {
            $url += "/$NoteId"
        }
        $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
        return $result
    }
}
