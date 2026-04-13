function Remove-WooCommerceOrderNote {
    <#
    .SYNOPSIS
        Delete a WooCommerce order note

    .DESCRIPTION
        This API helps you delete an order note. Order notes are private internal notes or customer messages
        attached to an order. This operation permanently removes the specified note from the order and cannot
        be undone.

    .PARAMETER id
        Unique identifier for the order from which the note will be deleted. This parameter is mandatory.
        Accepts 'OrderId' as an alias.

    .PARAMETER NoteId
        Unique identifier for the specific order note to delete. This parameter is mandatory and identifies
        which note within the order should be removed.

    .EXAMPLE
        PS C:\> Remove-WooCommerceOrderNote -id 123 -NoteId 456

        Deletes the note with ID 456 from order 123. A confirmation prompt will be displayed before deletion.

    .EXAMPLE
        PS C:\> Remove-WooCommerceOrderNote -id 123 -NoteId 456 -Confirm:$false

        Deletes the note without prompting for confirmation. Use with caution.

    .EXAMPLE
        PS C:\> Get-WooCommerceOrderNote -id 123 | ForEach-Object { 
            Remove-WooCommerceOrderNote -OrderId 123 -NoteId $_.id 
        }

        Deletes all notes from order 123. Each deletion requires confirmation.

    .NOTES
        Requires valid WooCommerce credentials set via Set-WooCommerceCredential.
        This cmdlet has a confirmation impact level of 'High', meaning confirmation will be requested
        for each deletion unless suppressed with -Confirm:$false.
        This cmdlet supports the ShouldProcess interface for pipeline integration and -WhatIf simulation.
        
    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#delete-an-order-note
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    [OutputType([PSObject])]
    param
    (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "The id of the order")]
        [Alias("OrderId")]
        [System.String]$id,
        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "The id of the note")]
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
        if ($pscmdlet.ShouldProcess("Remove order note $id")) {
            $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "GET"
            return $result
        }
        else {
            return $null
        }
    }
}

