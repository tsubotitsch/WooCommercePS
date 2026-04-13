function Update-WooCommerceCustomer
{
    <#
    .SYNOPSIS
        Update a WooCommerce customer

    .DESCRIPTION
        This API lets you make changes to a customer. You can update customer properties including
        billing and shipping addresses, email, name, and other customer data.

    .PARAMETER id
        Unique identifier for the customer resource. This parameter is mandatory.

    .PARAMETER email
        The email address for the customer.

    .PARAMETER first_name
        The first name of the customer.

    .PARAMETER last_name
        The last name of the customer.

    .PARAMETER username
        The login username for the customer.

    .PARAMETER password
        The password for the customer account.

    .PARAMETER role
        The role assigned to the customer (e.g., 'customer', 'administrator', 'editor').

    .PARAMETER billing
        A hashtable containing billing address fields. Valid keys include: first_name, last_name,
        company, address_1, address_2, city, state, postcode, country, email, phone.

    .PARAMETER shipping
        A hashtable containing shipping address fields. Valid keys include: first_name, last_name,
        company, address_1, address_2, city, state, postcode, country.

    .PARAMETER billing_first_name
        The first name for the billing address (alternative to using -billing hashtable).

    .PARAMETER billing_last_name
        The last name for the billing address.

    .PARAMETER billing_company
        The company name for the billing address.

    .PARAMETER billing_address_1
        The first line of the billing street address.

    .PARAMETER billing_address_2
        The second line of the billing street address.

    .PARAMETER billing_city
        The city for the billing address.

    .PARAMETER billing_state
        The state or province for the billing address.

    .PARAMETER billing_postcode
        The postal code for the billing address.

    .PARAMETER billing_country
        The country code (ISO 3166-1 alpha-2) for the billing address.

    .PARAMETER billing_email
        The email address for billing inquiries.

    .PARAMETER billing_phone
        The phone number for the billing address.

    .PARAMETER shipping_first_name
        The first name for the shipping address (alternative to using -shipping hashtable).

    .PARAMETER shipping_last_name
        The last name for the shipping address.

    .PARAMETER shipping_company
        The company name for the shipping address.

    .PARAMETER shipping_address_1
        The first line of the shipping street address.

    .PARAMETER shipping_address_2
        The second line of the shipping street address.

    .PARAMETER shipping_city
        The city for the shipping address.

    .PARAMETER shipping_state
        The state or province for the shipping address.

    .PARAMETER shipping_postcode
        The postal code for the shipping address.

    .PARAMETER shipping_country
        The country code (ISO 3166-1 alpha-2) for the shipping address.

    .PARAMETER meta_data
        An array of custom meta data objects. Each object should contain 'key' and 'value' properties.

    .EXAMPLE
        PS C:\> Update-WooCommerceCustomer -id 123 -email 'newemail@example.com'

        Updates the email address for customer with ID 123.

    .EXAMPLE
        PS C:\> Update-WooCommerceCustomer -id 123 -first_name 'John' -last_name 'Doe' `
            -billing_city 'Hamburg' -billing_country 'DE'

        Updates customer information including name and billing address.

    .EXAMPLE
        PS C:\> $billing = @{
                    first_name = 'John'
                    last_name = 'Doe'
                    address_1 = '123 Main Street'
                    city = 'Hamburg'
                    postcode = '20095'
                    country = 'DE'
                }
        Update-WooCommerceCustomer -id 123 -email 'john@example.com' -billing $billing

        Updates customer with a complete billing address using a hashtable.

    .NOTES
        Requires valid WooCommerce credentials set via Set-WooCommerceCredential.
        The -WhatIf parameter can be used to preview changes without applying them.
        This cmdlet supports the ShouldProcess interface for pipeline integration.

    .LINK
        https://woocommerce.github.io/woocommerce-rest-api-docs/#update-a-customer
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([PSObject])]
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "The id of the customer to update.")]
        [ValidateNotNullOrEmpty()]
        [System.String]$id,

        [Parameter(HelpMessage = "Customer email address.")]
        [System.String]$email,

        [Parameter(HelpMessage = "Customer first name.")]
        [System.String]$first_name,

        [Parameter(HelpMessage = "Customer last name.")]
        [System.String]$last_name,

        [Parameter(HelpMessage = "Login username for the customer.")]
        [System.String]$username,

        [Parameter(HelpMessage = "Password for the customer account.")]
        [System.String]$password,

        [Parameter(HelpMessage = "Customer role (e.g. 'customer').")]
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

        [Parameter(HelpMessage = "Array of meta data objects (e.g. @{key='foo';value='bar'}).")]
        [object[]]$meta_data
    )

    if (Get-WooCommerceCredential)
    {
        $url = "/customers/$id"
        if ($PSCmdlet.ShouldProcess("Update customer $id"))
        {
            $query = @{}

            # Top-level properties
            foreach ($kv in $PSBoundParameters.GetEnumerator())
            {
                if ($kv.Key -in @('id', 'billing', 'shipping', 'meta_data'))
                {
                    continue
                }
                $query[$kv.Key] = $kv.Value
            }

            # Billing fields
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

            # Shipping fields
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

            if ($query.Count -gt 0)
            {
                $json = $query | ConvertTo-Json -Depth 5
                $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "PUT" -Body $json
                return $result
            }
            else
            {
                Write-Error -Message "No value provided" -Category InvalidData
            }
        }
    }
}
