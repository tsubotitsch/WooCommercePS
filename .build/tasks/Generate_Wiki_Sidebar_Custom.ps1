task Generate_Wiki_Sidebar_Custom {
    #TODO: run script to generate wiki sidebar

    $SidebarParams = @{
        ModuleName     = Get-SamplerProjectName ..
        OutputPath     = $OutputDirectory
        WikiSourcePath = "$($OutputDirectory)WikiContent"
        #BaseName       = '_Sidebar.md'
        addHirachy     = $true
    }

    # Gesplatteter Befehl
    New-WikiSidebarCustom.ps1 @SidebarParams
}
