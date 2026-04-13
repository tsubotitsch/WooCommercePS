function Remove-WooCommerceCustomer {
    <#
    .SYNOPSIS
        Remove a WooCommerce customer

    .DESCRIPTION
        This API lets you remove a customer from WooCommerce.

    .PARAMETER id
        The id of the customer to remove.

    .EXAMPLE
        Remove-WooCommerceCustomer -id "123"

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    [OutputType([PSObject])]
    param
    (
        [Parameter(Position = 1, HelpMessage = "The id of the customer")]
        [ValidateNotNullOrEmpty()]
        [System.String]$id
    )

    if (Get-WooCommerceCredential) {
        $url = "/customers/$id"
        if ($PSCmdlet.ShouldProcess($id)) {
            $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "DELETE"
            return $result
        }
        else {
            return $null
        }
    }
}
