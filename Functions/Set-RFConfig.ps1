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
    (Get-FlyConfiguration).getenumerator().ForEach({
            $script:RFConfig[$_.Name] = $_.Value
        })
    if ($ClientSecret) {
        $script:RFConfig.ClientSecret = $ClientSecret
    }
}