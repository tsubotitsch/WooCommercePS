function Remove-WooCommerceProduct {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    [OutputType([PSObject])]
    param
    (
        [Parameter(Mandatory = $true,
            Position = 1)]
        [ValidateNotNullOrEmpty()]
        [System.String]$id,
        [switch]$permanently = $false
    )

    if ($pscmdlet.ShouldProcess("Remove product $id")) {
        if (Get-WooCommerceCredential) {
            $url = "/products/$id"
            if ($permanently) {
                $url += "?force=true"
            }
            Write-Debug "DELETE $url"
            $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "DELETE"
            return $result
        }
    }
 else {
        return $null
    }
}

