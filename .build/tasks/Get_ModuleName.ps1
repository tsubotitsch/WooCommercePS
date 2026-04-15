task Get_ModuleName {
    Write-Host -ForegroundColor Yellow "TS: Get_ModuleName"
    $ModuleName = Get-SamplerProjectName -BuildRoot "$PSScriptRoot/../.."
    Write-Host -ForegroundColor Yellow "Module Name: $ModuleName"

    return $ModuleName
}
