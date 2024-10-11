<#
.SYNOPSIS
    Reconnect to Fly API session if the token is about to expire.
.DESCRIPTION
    This function will check if the token is about to expire and reconnect to the Fly API if it is. Using the -force switch will force a new connection to be made regardless of the token expiry time.
.EXAMPLE
    Connect-RFSession
#>

function Connect-RFSession {
    [CmdletBinding()]
    param (
        # Force the a new connection to be made regardless of the token expiry time
        [Parameter(Mandatory = $false)]
        [switch]
        $Force
    )
    Set-RFConfig
    switch ($Force) {
        true {
            if ($null -eq $script:RFConfig.Certificate) {
                Connect-Fly -Url $script:RFConfig.Url -ClientId $script:RFConfig.ClientId -ClientSecret $script:RFConfig.ClientSecret
                Set-RFConfig
            }
            else {
                Connect-Fly -Url $script:RFConfig.Url -ClientId $script:RFConfig.ClientId -Certificate $script:RFConfig.Certificate
                Set-RFConfig
            }
        }
        false {
            $tokenInfo = Convert-JWTtoken $script:rfconfig.accesstoken
            $timeCheck = [System.TimeOnly]$(Get-Date $tokenInfo.exp -Format hh:mm:ss) - [System.TimeOnly]$(Get-Date -Format hh:mm:ss)
            if ($timeCheck.TotalMinutes -lt 15) {
                if ($null -eq $script:RFConfig.Certificate) {
                    if ($null -eq $script:RFConfig.ClientSecret) {
                        Write-Host 'Client Secret is not set. Please set the Client Secret using Set-RFConfig'
                        return
                    }
                    Connect-Fly -Url $script:RFConfig.Url -ClientId $script:RFConfig.ClientId -ClientSecret $script:RFConfig.ClientSecret
                    Set-RFConfig
                }
                else {
                    Connect-Fly -Url $script:RFConfig.Url -ClientId $script:RFConfig.ClientId -Certificate $script:RFConfig.Certificate
                    Set-RFConfig
                }
            }
        }
    }
}