<#
.SYNOPSIS
    Set the color code for a project mapping
.DESCRIPTION
    Provide the project ID, mapping ID, project type, and color code to set the color code for a project mapping.
.EXAMPLE
    Set-RFColorCode -ProjectId 6edd0465-fnb2-4298-a8a3-0523a6016aa6 -MappingId 12c0bf1a-5172-461a-9d98-3a209404c6d9 -ProjectType teams -Color black
#>
function Set-RFColorCode {
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

        # The color to set
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet('none', 'lightred', 'lightorange', 'lightyellow', 'lightgreen', 'lightteal', 'lightpurple', 'red', 'orange', 'yellow', 'green', 'teal', 'blue', 'darkred', 'darkorange', 'darkyellow', 'darkgreen', 'darkteal', 'darkblue', 'outline', 'lightgrey', 'grey', 'darkgrey', 'black')]
        [string]
        $Color
    )
    $colorCode = [int][ColorCode]::$Color
    $ProjectType = $ProjectType.ToLower()
    $URI = "/projects/$projectType/$projectId/colorcode"
    $fullURI = $script:RFConfig.BaseURL + $URI
    $authHeader = @{
        'Authorization' = "Bearer $($script:RFConfig.AccessToken)"
    }
    $body = [pscustomobject]@{
        'colorCode'   = $colorCode
        'isSelectAll' = $false
        'mappingIds'  = @($MappingId)
    }
    $account_params = @{
        URI     = $fullURI
        Method  = 'POST'
        Headers = $authHeader
        Body    = $body | ConvertTo-Json -Depth 10
    }
    $null = Invoke-RestMethod @Account_params -contentType 'application/json'

}