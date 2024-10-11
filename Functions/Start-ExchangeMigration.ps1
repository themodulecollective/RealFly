#todo inprogress. Finishing invoke-restmethod params

<#
.SYNOPSIS
    Start a migration job
.DESCRIPTION
    Start a migration job for one or several mappings in a project.

.EXAMPLE
    Start-ExchangeMigration -ProjectId <GUID> -Mode "FullMigration" -MappingId <GUID>
#>


function Start-ExchangeMigration {
    [CmdletBinding()]
    Param (
        # The project ID
        [Parameter(Mandatory = $true)]
        [String]
        ${ProjectId},
        # The migration mode
        [Parameter(Mandatory = $true)]
        [ValidateSet('FullMigration', 'IncrementalMigration', 'ErrorOnly', 'PermissionOnly')]
        [String]
        ${Mode},
        # The mapping ID or IDs
        [Parameter(Mandatory = $true)]
        [array]
        ${MappingId},
        # Schedule a time for the migration job to start
        [Parameter(Mandatory = $false)]
        [Datetime]
        ${ScheduleTime}
    )

    $configuration = Get-FlyConfiguration
    $authHeader = @{
        'Authorization' = "Bearer $($Configuration.AccessToken)"
    }
    $uri = $Configuration['BaseUrl'] + "/projects/exchange/$ProjectId/migrations"
    #Construct the settings of the migration job
    $jobSettings = [PSCustomObject]@{
        'type'          = $Mode
        'scheduledTime' = 0
        'isSelectAll'   = $true
        'mappingIds'    = $mappingId
    }
    $jobSettings.isSelectAll = $false

    if ($ScheduleTime) {
        $jobSettings.scheduledTime = $ScheduleTime.Ticks
    }
    $jobSettings
    # $result = Start-FlyExchangeMigrationJob -ProjectId $projectId -MigrationJobSettingsModel $jobSettings
    # Invoke-RestMethod -Method 'POST' -Headers $authHeader -Uri

}