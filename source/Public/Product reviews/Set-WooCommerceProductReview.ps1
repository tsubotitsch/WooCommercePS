function Set-WooCommerceProductReview {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([PSObject])]
    param
    (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "The id of the product")]
        [System.String]$product_id,
        [ValidateNotNullOrEmpty()]
        [System.String]$review,
        [ValidateNotNullOrEmpty()]
        [System.String]$reviewer,
        [System.String]$reviewer_email,
        [ValidateNotNullOrEmpty()]
        [System.String]$rating,
        [Parameter(HelpMessage = "The status of the review. Options: approved, hold, spam, unspam, trash, untrash. Default is approved.")]
        [ValidateSet('approved', 'hold', 'spam', 'unspam', 'trash', 'untrash')]
        [System.String]$status = 'approved'
    )

    $url = "/products/reviews"
    $query = @{
        product_id = $product_id
        reviewer   = $reviewer
        review     = $review
        rating     = $rating
        status     = $status
    }
    if ($reviewer_email) {
        $query += @{ reviewer_email = $reviewer_email }
    }

    $json = $query | ConvertTo-Json
    $result = Invoke-WooCommerceAPICall -RelativeUrl $url -Method "POST" -Body $json
    return $result
}

