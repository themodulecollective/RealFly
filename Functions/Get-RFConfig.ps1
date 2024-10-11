<#
.SYNOPSIS
    Get the current RFConfig object.
.DESCRIPTION
    Get the current RFConfig object containing the configuration settings for the connecting to the Fly api. Will only have a value if the Connect-Fly function has been called, followed by the Set-RFConfig function.
.EXAMPLE
    Get-RFConfig
#>


function Get-RFConfig {
    $script:RFConfig
}