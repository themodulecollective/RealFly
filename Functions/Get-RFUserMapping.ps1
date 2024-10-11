<#
.SYNOPSIS
    Get a user mapping summary for all jobs in a project.
.DESCRIPTION
    Provides a summary of all user mappings for a project. The summary includes the source and destination identity, project type, last job status, current job stage, current job status, fail comment, color, job progress, and id.
    For full mapping details, use Get-RFAllProjectMappings from the fly.client module.
.EXAMPLE
    Get-RFUserMapping -projectId <GUID>
#>


function Get-RFUserMapping {
    [CmdletBinding()]
    param (
        # The project id.
        [Parameter(Mandatory = $true)]
        [string]
        $projectId,
        # The failed flag only returns mappings with jobs that have failed.
        [switch]$failed
    )
    $projectName = Get-FlyProjects -Top 999 | Select-Object -ExpandProperty data | Where-Object { $_.id -eq $projectId } | Select-Object -ExpandProperty name
    $script:mappings = Get-FlyAllProjectMappings $projectId
    switch ($failed) {
        $true {
            $mappings = $mappings | Where-Object { $_.stageStatus -eq 6 }
        }
    }
    $mappings | Select-Object @{n = 'ProjectName'; e = { $projectName } },
    @{n = 'Source'; e = { $_.sourceIdentity } },
    @{n = 'Destination'; e = { $_.destinationIdentity } },
    @{n = 'ProjectType'; e = { [PlatformType].GetEnumName($_.sourcePlatform) } },
    @{n = 'LastJobStatus'; e = { [ProjectMappingItemStageStatus].GetEnumName($_.lastMigrationStatus) } },
    # @{n = 'UserLastMigrationStartTime'; e = { $(Get-Date $_.lastMigrationStartTime -Format "yyyy-MM-dd HH:mm:ss") } },
    @{n = 'CurrentJobStage'; e = { [ProjectMappingItemStage].GetEnumName($_.stage) } },
    @{n = 'CurrentJobStatus'; e = { [ProjectMappingItemStageStatus].GetEnumName($_.stageStatus) } },
    @{n = 'FailComment'; e = { if ($_.stageStatus -eq 6) { Get-RFRecentJobComment -projectid $_.projectid -mappingid $_.id -projecttype $([PlatformType].GetEnumName($_.sourcePlatform)).ToLower() } } },
    @{n = 'Color'; e = { [ColorCode].GetEnumName($_.ColorCode) } },
    jobProgress,
    id
    #,*
}