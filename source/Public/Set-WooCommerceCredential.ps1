function Set-WooCommerceCredential {
    <#
    .SYNOPSIS
    Sets the authentication credentials for WooCommerce REST API communication.

    .DESCRIPTION
    The Set-WooCommerceCredential function configures the credentials and base URL required to authenticate
    with the WooCommerce REST API. It validates the credentials by making a test connection to the
    WooCommerce installation and stores them in script-scoped variables for use by other WooCommercePS cmdlets.

    Authentication is performed using HTTP Basic Authentication, where the API key and API secret are
    encoded in Base64 and sent with each API request.

    .PARAMETER url
    The root URL of your WooCommerce installation (e.g., https://example.com).
    This is the base URL to which all API endpoints will be appended.

    .PARAMETER apiKey
    The consumer key generated in the WooCommerce API credentials settings.
    This is username in the HTTP Basic Authentication scheme.

    .PARAMETER apiSecret
    The consumer secret generated in the WooCommerce API credentials settings.
    This is the password in the HTTP Basic Authentication scheme.

    .INPUTS
    None. You cannot pipe input to Set-WooCommerceCredential.

    .OUTPUTS
    None. Set-WooCommerceCredential does not produce any output.

    .EXAMPLE
    Set-WooCommerceCredential -url 'https://mystore.com' -apiKey 'ck_1234567890' -apiSecret 'cs_1234567890'

    This example sets the WooCommerce credentials for the store at https://mystore.com.

    .NOTES
    - The credentials are stored in script-scoped variables accessible to other WooCommercePS cmdlets.
    - A connection test is performed automatically to validate the provided credentials.
    - If the credentials are invalid or the URL is incorrect, an error is thrown.
    - The function supports the WhatIf (-WhatIf) parameter for testing.
    - To generate API credentials, log in to your WooCommerce admin panel and navigate to Settings > Advanced > REST API.

    .RELATED LINKS
    https://woocommerce.github.io/woocommerce-rest-api-docs/
    Get-WooCommerceCredential
    Invoke-WooCommerceAPICall
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([void])]
    param
    (
        [Parameter(Mandatory = $true,
            Position = 1, HelpMessage = "The root url of your WooCommerce installation")]
        [ValidateNotNullOrEmpty()]
        [System.String]$url,
        [Parameter(Mandatory = $true,
            Position = 2, ParameterSetName = "UsernamePassword", HelpMessage = "The api key provided by WooCommerce")]
        [ValidateNotNullOrEmpty()]
        [System.String]$apiKey,
        [Parameter(Mandatory = $true,
            Position = 3, ParameterSetName = "UsernamePassword", HelpMessage = "The api secret provided by WooCommerce")]
        [ValidateNotNullOrEmpty()]
        [System.String]$apiSecret
        # [Parameter(Mandatory = $true,
        # 	Position = 2, ParameterSetName = "Credential")]
        # [System.Management.Automation.PSCredential]$APICredential
    )

    if ($PSCmdlet.ShouldProcess("Check if the provided credentials and uri is correct")) {
        try {
            Write-Debug "GET $url/$script:woocommerceApiPrefix"
            Write-Debug (@{ Authorization = "Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $apiKey, $apiSecret))) } | Out-String)
            Invoke-RestMethod -Method GET -Uri "$url/$script:woocommerceApiPrefix" -Headers @{ Authorization = "Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $apiKey, $apiSecret))) } -ErrorAction Stop | Out-Null
            # $authHeader = @{
            # 	Authorization = "Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $apiKey, $apiSecret)))
            # }
            # $invokeParams = @{
            # 	Method      = 'GET'
            # 	Uri         = "$url/$script:woocommerceApiPrefix"
            # 	Headers     = $authHeader
            # 	ErrorAction = 'Stop'
            # }
            # Write-Debug ($invokeParams | Out-String)
            # Invoke-WooCommerceAPICall @invokeParams | Out-Null

            $script:woocommerceApiSecret = $apiSecret
            $script:woocommerceApiKey = $apiKey
            $script:woocommerceBase64AuthInfo = @{
                Authorization = ("Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $script:woocommerceApiKey, $script:woocommerceApiSecret))))
            }
            $script:woocommerceUrl = $url
        }
        catch {
            Write-Error -Message "Wrong Credentials or URL" -Category AuthenticationError -RecommendedAction "Please provide valid Credentials or the right uri"
        }
    }
}
