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
    Write-Information "Getting error codes for project $ProjectId and mapping $MappingId with project type $ProjectType"
    $Uri = "/projects/$projectType/$projectId/mappings/$mappingId/reporterrorcodes"
    $result = Get-RFNextPage -URI $Uri
    $result.errorCodes
}