<#
.SYNOPSIS
    List the error codes for a specific job and their item count.
.DESCRIPTION
    List the error codes for a specific job and their item count.
.EXAMPLE
    Get-RFJobErrorCode -ProjectId <GUID> -MappingId <GUID> -ProjectType "exchange"
#>


function Get-RFJobErrorCode {
    [CmdletBinding()]
    param (
        # The Fly project ID
        [Parameter(Mandatory = $true)]
        [string]
        $ProjectId,

        # The migration job mapping ID
        [Parameter(Mandatory = $true)]
        [string]
        $MappingId,

        # The project type
        [Parameter(Mandatory = $true)]
        [string]
        [ValidateSet('exchange', 'onedrive', 'sharedoint', 'teams', 'teamchat', 'm365group')]
        $ProjectType
    )
    Connect-RFSession
    $Uri = "/projects/$projectType/$projectId/mappings/$mappingId/reportsummary"
    $result = Get-RFNextPage -URI $Uri
    $result.errorCodes
}