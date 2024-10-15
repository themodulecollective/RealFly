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
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId,

        # The migration job mapping ID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $MappingId,

        # The project type
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet('exchange', 'onedrive', 'sharedoint', 'teams', 'teamchat', 'm365group')]
        [string]
        $ProjectType
    )
    $ProjectType = $ProjectType.ToLower()
    $Uri = "/projects/$projectType/$projectId/mappings/$mappingId/errordetails"
    $result = Get-RFNextPage -URI $Uri
    $result.data
}