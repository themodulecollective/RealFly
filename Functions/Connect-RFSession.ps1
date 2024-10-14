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
    Write-Information 'RF config set'
    switch ($Force) {
        true {
            Write-Information 'Forcing a new connection to Fly API'
            if ($null -eq $script:RFConfig.Certificate) {
                Connect-Fly -Url $script:RFConfig.BaseUrl -ClientId $script:RFConfig.ClientId -ClientSecret $script:RFConfig.ClientSecret
                Set-RFConfig
                Write-Information 'RF config set with new connection information'
            }
            else {
                Connect-Fly -Url $script:RFConfig.BaseUrl -ClientId $script:RFConfig.ClientId -Certificate $script:RFConfig.Certificate
                Set-RFConfig
            }
            Write-Information 'Connection updated'
            Write-Information 'RF config set with new connection information'
        }
        false {
            $timeCheck = $(Get-Date) - $(Get-Date $script:RFConfig.tokentime)
            Write-Information "Token has been active for $timeCheck"
            if ($timeCheck.TotalMinutes -gt 60) {
                Write-Information 'Token is about to expire. Reconnecting to Fly API'
                if ($null -eq $script:RFConfig.Certificate) {
                    if ($null -eq $script:RFConfig.ClientSecret) {
                        Write-Host 'Client Secret is not set. Please set the Client Secret using Set-RFConfig'
                        return
                    }
                    Connect-Fly -Url $script:RFConfig.BaseUrl -ClientId $script:RFConfig.ClientId -ClientSecret $script:RFConfig.ClientSecret
                    Set-RFConfig
                }
                else {
                    Connect-Fly -Url $script:RFConfig.BaseUrl -ClientId $script:RFConfig.ClientId -Certificate $script:RFConfig.Certificate
                    Set-RFConfig
                }
                Write-Information 'Connection updated'
                Write-Information 'RF config set with new connection information'
            }
        }
    }
}