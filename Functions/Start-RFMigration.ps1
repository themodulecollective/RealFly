<#
.SYNOPSIS
    Start a migration job for a project mapping.
.DESCRIPTION
    Start a migration job for a project mapping.
.EXAMPLE
    Start-RFMigration -ProjectId 6edd0465-fnb2-4298-a8a3-0523a6016aa6 -MappingId 12c0bf1a-5172-461a-9d98-3a209404c6d9 -ProjectType teams -MigrationType incrementalmigration
#>
function Start-RFMigration {
    [CmdletBinding()]
    param (
        # The Fly project ID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId,

        # The migration job mapping ID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string[]]
        $MappingId,

        # The project type
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet('exchange', 'onedrive', 'sharepoint', 'teams', 'teamchat', 'm365group')]
        [string]
        $ProjectType,

        # Set the migration type
        [Parameter(Mandatory)]
        [ValidateSet('validation', 'emailforwarding', 'fullmigration', 'incrementalmigration', 'erroronly', 'permissiononly', 'membershiponly', 'assessment', 'generatereport', 'generateerrorreport', 'keepx500emailaddress', 'migratemailboxaliases', 'completemigration')]
        [string]
        $MigrationType,

        # Schedule the migration time to start. Fly will use UTC for the time.
        [Parameter(Mandatory = $false)]
        [datetime]
        $ScheduledTimeUTC
    )
    $type = [int][MappingJobType ]::$MigrationType
    if ($ScheduledTime) {
        [string]$ScheduledTime = (get-date $scheduledtime).ticks
    }
    else {
        $ScheduledTime = 0
    }
    $ProjectType = $ProjectType.ToLower()
    $URI = "/projects/$projectType/$projectId/migrations"
    $fullURI = $script:RFConfig.BaseURL + $URI
    $authHeader = @{
        'Authorization' = "Bearer $($script:RFConfig.AccessToken)"
    }
    $body = [pscustomobject]@{
        'type'          = $type
        'scheduledTime' = $ScheduledTime
        # 'search' = ''
        # 'stageStatuses' = @()
        # 'statuses'= @()
        # 'destinationStatuses'= @()
        # 'lastMigrationStatus'= @()
        # 'objectTypes'= @()
        # 'colorCodes'   = @()
        'isSelectAll'   = $false
        'mappingIds'    = @($MappingId)
    }
    $account_params = @{
        URI     = $fullURI
        Method  = 'POST'
        Headers = $authHeader
        Body    = $body | ConvertTo-Json -Depth 10
    }
    $null = Invoke-RestMethod @Account_params -contentType 'application/json'

}