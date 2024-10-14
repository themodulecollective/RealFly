<#
.SYNOPSIS
    List the error details for a specific job.
.DESCRIPTION
    List the error details for a specific job. Each error will have an entry
.EXAMPLE
    Get-RFJobErrorDetails -ProjectId <GUID> -MappingId <GUID> -ProjectType "exchange"
#>


function Get-RFJobErrorDetails {
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
    $Uri = "/projects/$projectType/$projectId/mappings/$mappingId/errordetails"
    $result = Get-RFNextPage -URI $Uri
    $result.data
}