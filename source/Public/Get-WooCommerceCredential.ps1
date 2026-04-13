function Get-WooCommerceCredential
{
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if ($script:woocommerceUrl -and $script:woocommerceBase64AuthInfo)
    {
        return $true
    }
    else
    {
        Write-Error -Message "You have to run 'Set-WooCommerceCredential' first" -Category AuthenticationError
        return $false
    }
}

