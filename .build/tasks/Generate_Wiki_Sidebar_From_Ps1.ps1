task Generate_Wiki_Sidebar_From_Ps1 {
    $error.Clear()
    Write-Host -ForegroundColor Yellow "TS: Generate_Wiki_Sidebar_From_Ps1"
    $SidebarParamsPs1 = @{
        SourcePathPs1  = "$(Get-SamplerAbsolutePath)/source/Public"
        #OutputPath = $OutputDirectory
        WikiSourcePath = Join-Path $OutputDirectory "WikiContent"
        # SidebarFile = '_Sidebar.md'
    }
    Write-Host -ForegroundColor Yellow $SidebarParamsPs1
    New-WikiSidebarFromPs1 @SidebarParamsPs1
    Get-Error | Out-String | Write-Host -ForegroundColor Yellow
}
