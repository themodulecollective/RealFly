<#
.SYNOPSIS
    Get the configuration of the current Fly session and store it in a module variable.
.DESCRIPTION
    Get the configuration of the current Fly session and store it in a module variable. Should only be used after successful Connect-Fly.

    If a ClientSecret is used to connect to the Fly API, use the -ClientSecret parameter to update the ClientSecret in the module variable. Connect-RFSession will fail if the ClientSecret is not set in the module variable.
.EXAMPLE
    Set-RFConfig
#>


function Set-RFConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]
        # Store the ClientSecret in the module variable for Connect-RFSession reconnections to the Fly API
        $ClientSecret
    )
    $flyConfig = Get-FlyConfiguration
    Write-Information "Fly configuration imported"
    # At the time of writing this function, the fly accesstoken expiration date fixed at 12:02:52 AM. Adding $timetoken to RFConfig to check if the accesstoken is still valid.
    $tokenTime = get-date
    if ($flyConfig.accesstoken -ne $script:RFConfig.AccessToken) {
        $script:RFConfig['TokenTime'] = $tokenTime
        write-information "TokenTime updated to $tokenTime"
    }
    write-information "Updating RF configuration with Fly configuration information"
    $flyConfig.getenumerator().ForEach({
            $script:RFConfig[$_.Name] = $_.Value
        })
    if ($ClientSecret) {
        $script:RFConfig.ClientSecret = $ClientSecret
        Write-Information "ClientSecret updated in RFConfig"
    }
}