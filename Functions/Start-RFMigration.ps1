function Start-RFMigration {
    [CmdletBinding()]
    param (
        # The Fly project ID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId,

        # The migration job mapping ID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        $MappingId,

        # The project type
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet('exchange', 'onedrive', 'sharepoint', 'teams', 'teamchat', 'm365group')]
        [string]
        $ProjectType,

        # The color to set
        [Parameter(Mandatory)]
        [ValidateSet('validation', 'emailforwarding', 'fullmigration', 'incrementalmigration', 'erroronly', 'permissiononly', 'membershiponly', 'assessment', 'generatereport', 'generateerrorreport', 'keepx500emailaddress', 'migratemailboxaliases', 'completemigration')]
        [string]
        $MigrationType
    )
    $type = [int][MappingJobType ]::$MigrationType

    $ProjectType = $ProjectType.ToLower()
    $URI = "/projects/$projectType/$projectId/migrations"
    $fullURI = $script:RFConfig.BaseURL + $URI
    $authHeader = @{
        'Authorization' = "Bearer $($script:RFConfig.AccessToken)"
    }
    $body = [pscustomobject]@{
        'type'          = $type
        'scheduledTime' = 0
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