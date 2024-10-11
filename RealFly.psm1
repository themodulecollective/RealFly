# Implement your module commands in this script.


# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
$ModuleFolder = Split-Path $PSCommandPath -Parent
# $Scripts = Join-Path -Path $ModuleFolder -ChildPath 'scripts'
$Functions = Join-Path -Path $ModuleFolder -ChildPath 'Functions'
$Script:ModuleFiles = @(
    # Load Functions
    $(Join-Path -Path $Functions -ChildPath 'Get-RFConfig.ps1')
    $(Join-Path -Path $Functions -ChildPath 'Get-RFRecentJobComment.ps1')
    $(Join-Path -Path $Functions -ChildPath 'Get-RFJobErrorCode.ps1')
    $(Join-Path -Path $Functions -ChildPath 'Get-RFJobErrorDetails.ps1')
    $(Join-Path -Path $Functions -ChildPath 'Get-RFUserMapping.ps1')
    $(Join-Path -Path $Functions -ChildPath 'Get-RFNextPage.ps1')
    $(Join-Path -Path $Functions -ChildPath 'Connect-RFSession.ps1')
    $(Join-Path -Path $Functions -ChildPath 'Get-RFUserMapping.ps1')
    $(Join-Path -Path $Functions -ChildPath 'Set-RFConfig.ps1')
)

foreach ($f in $ModuleFiles) {
    . $f
}

# Module-level variable
$RFConfig = @{}

# Load fly.client Models
$modelsRootPath = $(get-module fly.Client).path.split('Fly.Client.psm1') -join "Model"
. $modelsRootPath\PlatformType.ps1
. $modelsRootPath\ProjectMappingItemStage.ps1
. $modelsRootPath\ProjectMappingItemStageStatus.ps1
. $modelsRootPath\ColorCode.ps1