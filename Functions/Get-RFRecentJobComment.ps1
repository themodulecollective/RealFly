<#
.SYNOPSIS
    Get most recent the comment for the migration job for non-successful jobs.
.DESCRIPTION
    Get most recent the comment for the migration job for non-successful jobs.

    Example of a failed exchange job comment:
    "There is no available quota in the destination archive mailbox. You can manually delete some data in the destination archive mailbox to release the quota and rerun the migration job."
.EXAMPLE
    Get-RFRecentJobComment -ProjectId <GUID> -MappingId <GUID> -ProjectType "exchange"
#>
function Get-RFRecentJobComment {
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
    $result.historicalJobs[0].comments.comment
}

