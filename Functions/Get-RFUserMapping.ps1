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
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [string]
        $ProjectId,
        # The failed flag only returns mappings with jobs that have failed.
        [Parameter(Mandatory = $false)]
        [switch]
        $Failed,
        # The IncludeAllFields flag returns all fields including non-human-readable fields.
        [Parameter(Mandatory = $false)]
        [switch]
        $IncludeAllFields
    )
    Connect-RFSession
    $projectName = Get-FlyProjects -Top 999 | Select-Object -ExpandProperty data | Where-Object { $_.id -eq $projectId } | Select-Object -ExpandProperty name
    $script:mappings = Get-FlyAllProjectMappings $projectId
    switch ($failed) {
        true {
            $mappings = $mappings | Where-Object { $_.stageStatus -eq 6 }
        }
    }
    switch ($IncludeAllFields) {
        true {
            $mappings | Select-Object @{n = 'ProjectName'; e = { $projectName } },
            @{n = 'Color'; e = { [ColorCode].GetEnumName($_.ColorCode) } },
            @{n = 'ProjectType'; e = { [PlatformType].GetEnumName($_.sourcePlatform) } },
            @{n = 'Source'; e = { $_.sourceIdentity } },
            @{n = 'Destination'; e = { $_.destinationIdentity } },
            @{n = 'CurrentJobStatus'; e = { [ProjectMappingItemStageStatus].GetEnumName($_.stageStatus) } },
            @{n = 'CurrentJobStage'; e = { [ProjectMappingItemStage].GetEnumName($_.stage) } },
            @{n = 'LastJobStatus'; e = { [ProjectMappingItemStageStatus].GetEnumName($_.lastMigrationStatus) } },
            @{n = 'FailComment'; e = { if ($_.stageStatus -eq 6) { Get-RFRecentJobComment -projectid $_.projectid -mappingid $_.id -projecttype $([PlatformType].GetEnumName($_.sourcePlatform)).ToLower() } } },
            @{n = 'MappingId'; e = { $_.id } },
            *
        }
        false {
            $mappings.ForEach({
                    [PSCustomObject]@{
                        ProjectName      = $projectName
                        ProjectType      = [PlatformType].GetEnumName($_.sourcePlatform)
                        Color            = [ColorCode].GetEnumName($_.ColorCode)
                        Source           = $_.sourceIdentity
                        Destination      = $_.destinationIdentity
                        CurrentJobStatus = [ProjectMappingItemStageStatus].GetEnumName($_.stageStatus)
                        CurrentJobStage  = [ProjectMappingItemStage].GetEnumName($_.stage)
                        LastJobStatus    = [ProjectMappingItemStageStatus].GetEnumName($_.lastMigrationStatus)
                        FailComment      = if ($_.stageStatus -eq 6) {
                            Get-RFRecentJobComment -projectid $_.projectid -mappingid $_.id -projecttype $([PlatformType].GetEnumName($_.sourcePlatform)).ToLower()
                        }
                        JobProgress      = $_.jobProgress
                        MappingId        = $_.id
                        ProjectId        = $projectId
                    }
                })
        }
    }
}