<#
.SYNOPSIS
    When using GET, this function will return all results from a paginated API call
.DESCRIPTION
    When using GET, this function will return all results from a paginated API call
.EXAMPLE
    Get-RFNextPage -URI <url>
#>


Function Get-RFNextPage {
    [CmdletBinding()]
    param (
        # URI of the api call endpoint
        [Parameter(Mandatory = $True)]
        [string]
        $URI,
        # If the uri is provided by NextLink it will inlcude the full uri and not just the endpoint
        [switch]
        $Nextlink

    )
    Connect-RFSession
    switch ($Nextlink) {
        true {
            $fullURI = $URI
        }
        false {
            $fullURI = $script:RFConfig.BaseURL + $URI
        }
    }

    $authHeader = @{
        'Authorization' = "Bearer $($script:RFConfig.AccessToken)"
    }
    $account_params = @{
        URI     = $fullURI
        Method  = 'GET'
        Headers = $authHeader
    }
    $Result = Invoke-RestMethod @Account_params
    $Result.data
    if ($result.data.nextlink) {
        Get-RFNextPage -Uri $result.data.nextlink -Nextlink
    }
}

