# WooCommercePS

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/WooCommercePS?label=PSGallery%20Version)](https://www.powershellgallery.com/packages/WooCommercePS)
[![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/WooCommercePS?label=Downloads)](https://www.powershellgallery.com/packages/WooCommercePS)
![Platform](https://img.shields.io/badge/Platform-Windows|Linux|MacOS-blue)
[![GitHub Issues](https://img.shields.io/github/issues/tsubotitsch/WooCommercePS?label=Issues)](https://github.com/tsubotitsch/WooCommercePS/issues)

PowerShell module for managing the WooCommerce shop system

For detailed API reference, see the [WooCommerce API documentation](https://woocommerce.github.io/woocommerce-rest-api-docs/#).

## Functions


## First Steps

### Getting an API Key

First, you'll need an API key from your WooCommerce account:
1. Log in to your WooCommerce admin dashboard.
2. Navigate to **WooCommerce > Settings > Advanced > REST API**.
3. Click on "Add Key".
4. Fill in the description, select the user, and set permissions to "Read/Write".
5. Click "Generate API Key" and note down the Consumer Key and Consumer Secret.
6. Use these credentials to connect to the WooCommerce API from PowerShell.
7. You can use the `Connect-WooCommerce` function to establish a connection using your API credentials.

Example:
   ```powershell
   Connect-WooCommerce -ConsumerKey "your_consumer_key" -ConsumerSecret "your_consumer_secret" -StoreUrl "https://yourstore.com"
   ```
