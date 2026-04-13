function New-WooCommerceCustomer {
    <#
    .SYNOPSIS
        Create a new WooCommerce customer

    .DESCRIPTION
        This API lets you create a new customer in WooCommerce.

    .PARAMETER email
        Customer email address (required).

    .PARAMETER first_name
        Customer first name.

    .PARAMETER last_name
        Customer last name.

    .PARAMETER username
        Login username for the customer.

    .PARAMETER password
        Password for the new customer account.

    .PARAMETER role
        Customer role. Examples: 'customer', 'subscriber'.

    .PARAMETER billing
        Hashtable with billing address fields.

    .PARAMETER shipping
        Hashtable with shipping address fields.

    .PARAMETER billing_first_name
        Billing first name (alternative to -billing).

    .PARAMETER billing_last_name
        Billing last name (alternative to -billing).

    .PARAMETER billing_company
        Billing company.

    .PARAMETER billing_address_1
        Billing address line 1.

    .PARAMETER billing_address_2
        Billing address line 2.

    .PARAMETER billing_city
        Billing city.

    .PARAMETER billing_state
        Billing state/province.

    .PARAMETER billing_postcode
        Billing postal code.

    .PARAMETER billing_country
        Billing country code (e.g. 'US').

    .PARAMETER billing_email
        Billing email address.

    .PARAMETER billing_phone
        Billing phone number.

    .PARAMETER shipping_first_name
        Shipping first name (alternative to -shipping).

    .PARAMETER shipping_last_name
        Shipping last name (alternative to -shipping).

    .PARAMETER shipping_company
        Shipping company.

    .PARAMETER shipping_address_1
        Shipping address line 1.

    .PARAMETER shipping_address_2
        Shipping address line 2.

    .PARAMETER shipping_city
        Shipping city.

    .PARAMETER shipping_state
        Shipping state/province.

    .PARAMETER shipping_postcode
        Shipping postal code.

    .PARAMETER shipping_country
        Shipping country code (e.g. 'US').

    .PARAMETER meta_data
        Array of meta data objects (e.g. @{key='privacy_policy_reg';value='1'}).

    .EXAMPLE
        New-WooCommerceCustomer -email "john.doe@example.com" -first_name "John" -last_name "Doe"

    .NOTES
        Requires valid WooCommerce credentials (Set-WooCommerceCredential).
#>
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([PSObject])]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Customer email address (required).")]
        [ValidateNotNullOrEmpty()]
        [System.String]$email,

        [Parameter(HelpMessage = "Customer first name.")]
        [System.String]$first_name,

        [Parameter(HelpMessage = "Customer last name.")]
        [System.String]$last_name,

        [Parameter(HelpMessage = "Login username for the customer.")]
        [System.String]$username,

        [Parameter(HelpMessage = "Password for the new customer account.")]
        [System.String]$password,

        [Parameter(HelpMessage = "Customer role. Examples: 'customer', 'subscriber'.")]
        [System.String]$role,

        [Parameter(HelpMessage = "Hashtable with billing address fields.")]
        [hashtable]$billing,

        [Parameter(HelpMessage = "Hashtable with shipping address fields.")]
        [hashtable]$shipping,

        [Parameter(HelpMessage = "Billing first name (alternative to -billing).")]
        [System.String]$billing_first_name,
        [Parameter(HelpMessage = "Billing last name (alternative to -billing).")]
        [System.String]$billing_last_name,
        [Parameter(HelpMessage = "Billing company.")]
        [System.String]$billing_company,
        [Parameter(HelpMessage = "Billing address line 1.")]
        [System.String]$billing_address_1,
        [Parameter(HelpMessage = "Billing address line 2.")]
        [System.String]$billing_address_2,
        [Parameter(HelpMessage = "Billing city.")]
        [System.String]$billing_city,
        [Parameter(HelpMessage = "Billing state/province.")]
        [System.String]$billing_state,
        [Parameter(HelpMessage = "Billing postal code.")]
        [System.String]$billing_postcode,
        [Parameter(HelpMessage = "Billing country code (e.g. 'US').")]
        [System.String]$billing_country,
        [Parameter(HelpMessage = "Billing email address.")]
        [System.String]$billing_email,
        [Parameter(HelpMessage = "Billing phone number.")]
        [System.String]$billing_phone,

        [Parameter(HelpMessage = "Shipping first name (alternative to -shipping).")]
        [System.String]$shipping_first_name,
        [Parameter(HelpMessage = "Shipping last name (alternative to -shipping).")]
        [System.String]$shipping_last_name,
        [Parameter(HelpMessage = "Shipping company.")]
        [System.String]$shipping_company,
        [Parameter(HelpMessage = "Shipping address line 1.")]
        [System.String]$shipping_address_1,
        [Parameter(HelpMessage = "Shipping address line 2.")]
        [System.String]$shipping_address_2,
        [Parameter(HelpMessage = "Shipping city.")]
        [System.String]$shipping_city,
        [Parameter(HelpMessage = "Shipping state/province.")]
        [System.String]$shipping_state,
        [Parameter(HelpMessage = "Shipping postal code.")]
        [System.String]$shipping_postcode,
        [Parameter(HelpMessage = "Shipping country code (e.g. 'US').")]
        [System.String]$shipping_country,

        [Parameter(HelpMessage = "Array of meta data objects (e.g. @{key='privacy_policy_reg';value='1'}).")]
        [object[]]$meta_data
    )

    if (Get-WooCommerceCredential)
    {
        $url = "/customers"
        if ($PSCmdlet.ShouldProcess("Create new customer $email"))
        {
            $query = @{
                email = $email
            }

            # Top-level simple properties
            foreach ($kv in $PSBoundParameters.GetEnumerator())
            {
                if ($kv.Key -in @('email', 'billing', 'shipping', 'meta_data'))
                {
                    continue
                }
                switch ($kv.Key)
                {
                    'first_name'
                    {
                        $query.first_name = $kv.Value
                    }
                    'last_name'
                    {
                        $query.last_name = $kv.Value
                    }
                    'username'
                    {
                        $query.username = $kv.Value
                    }
                    'password'
                    {
                        $query.password = $kv.Value
                    }
                    'role'
                    {
                        $query.role = $kv.Value
                    }
                    default
                    {
                    }
                }
            }

            # Collect billing fields from either -billing hashtable or individual billing_* params
            $billingObj = @{ }
            if ($PSBoundParameters.ContainsKey('billing') -and $billing)
            {
                foreach ($k in $billing.Keys)
                {
                    $billingObj[$k] = $billing[$k]
                }
            }
            foreach ($b in @('billing_first_name', 'billing_last_name', 'billing_company', 'billing_address_1', 'billing_address_2', 'billing_city', 'billing_state', 'billing_postcode', 'billing_country', 'billing_email', 'billing_phone'))
            {
                if ($PSBoundParameters.ContainsKey($b))
                {
                    $key = $b -replace '^billing_', ''
                    $billingObj[$key] = Get-Variable -Name $b -ValueOnly
                }
            }
            if ($billingObj.Count -gt 0)
            {
                $query.billing = $billingObj
            }

            # Collect shipping fields from either -shipping hashtable or individual shipping_* params
            $shippingObj = @{ }
            if ($PSBoundParameters.ContainsKey('shipping') -and $shipping)
            {
                foreach ($k in $shipping.Keys)
                {
                    $shippingObj[$k] = $shipping[$k]
                }
            }
            foreach ($s in @('shipping_first_name', 'shipping_last_name', 'shipping_company', 'shipping_address_1', 'shipping_address_2', 'shipping_city', 'shipping_state', 'shipping_postcode', 'shipping_country'))
            {
                if ($PSBoundParameters.ContainsKey($s))
                {
                    $key = $s -replace '^shipping_', ''
                    $shippingObj[$key] = Get-Variable -Name $s -ValueOnly
                }
            }
            if ($shippingObj.Count -gt 0)
            {
                $query.shipping = $shippingObj
            }

            if ($PSBoundParameters.ContainsKey('meta_data') -and $meta_data)
            {
                $query.meta_data = $meta_data
            }

            $json = $query | ConvertTo-Json -Depth 5
            $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "POST" -Body $json
            return $result
        }
    }
}
