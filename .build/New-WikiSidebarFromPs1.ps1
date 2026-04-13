<#
.SYNOPSIS
    Generates a wiki sidebar from PowerShell script files.

.DESCRIPTION
    Creates a Markdown sidebar file that indexes all PowerShell scripts in a directory tree,
    organizing them hierarchically with Home and Commands sections.

.PARAMETER SourcePathPs1
    The root path containing the PowerShell script files to index.

.PARAMETER WikiSourcePath
    The output directory where the generated sidebar file will be created.

.PARAMETER SidebarFile
    The name of the sidebar file to create. Defaults to '_Sidebar.md'.

.EXAMPLE
    New-WikiSidebarFromPs1 -SourcePathPs1 "C:\Scripts\Public" -WikiSourcePath "C:\Wiki"

.NOTES
    The function recursively processes all subdirectories and generates a tree-like structure
    in the sidebar file.
#>
function New-WikiSidebarFromPs1
{
    param(
        [Parameter(Mandatory)]
        [string]$SourcePathPs1,
        [Parameter(Mandatory)]
        [string]$WikiSourcePath,
        [string]$SidebarFile = "_Sidebar.md"
    )
    <#
    .SYNOPSIS
        Recursively builds the sidebar content tree structure.

    .DESCRIPTION
        Processes a directory and its subdirectories, creating markdown list entries
        for all PowerShell files and nested directories with proper indentation levels.

    .PARAMETER CurrentPath
        The current directory path to process.

    .PARAMETER Depth
        The current recursion depth for proper indentation. Defaults to 0.

    .EXAMPLE
        Build-Sidebar -CurrentPath "C:\Scripts" -Depth 0
    #>
    function Build-Sidebar
    {
        param(
            [string]$CurrentPath,
            [int]$Depth = 0
        )
        $indent = '  ' * $Depth
        $sidebar = ""

        # Zuerst die .ps1-Dateien im aktuellen Verzeichnis
        $files = Get-ChildItem -Path $CurrentPath -Filter *.ps1 -File | Where-Object { $_.Name -notlike '*.local.*' } | Sort-Object Name
        foreach ($file in $files)
        {
            $relPath = $($file.BaseName)
            if ($CurrentPath -ne $SourcePath)
            {
                $relDir = $file.DirectoryName.Substring($SourcePath.Length).TrimStart('\', '/')
                $relPath = "$relDir/$($file.BaseName)" -replace '\\', '/'
            }
            $sidebar += "$indent- [$($file.BaseName)]($($file.BaseName))`n"
            # # .md-Datei anlegen, falls nicht vorhanden
            # $mdOutDir = Join-Path $WikiSourcePath ($file.DirectoryName.Substring($SourcePath.Length).TrimStart('\','/'))
            # if (-not (Test-Path $mdOutDir)) { New-Item -ItemType Directory -Path $mdOutDir -Force | Out-Null }
            # $mdOutFile = Join-Path $mdOutDir $mdName
            # if (-not (Test-Path $mdOutFile)) { Set-Content -Path $mdOutFile -Value "# $($file.BaseName)" }
        }

        # Danach die Unterverzeichnisse
        $dirs = Get-ChildItem -Path $CurrentPath -Directory | Sort-Object Name
        foreach ($dir in $dirs)
        {
            $sidebar += "$indent- $($dir.Name)`n"
            $sidebar += Build-Sidebar -CurrentPath $dir.FullName -Depth ($Depth + 1)
        }
        return $sidebar
    }

    $sidebar = "[Home](HOME.md)`n`n"
    $sidebar += "### Commands`n`n"
    $sidebar += Build-Sidebar -CurrentPath $SourcePathPs1

    $sidebarFilePath = Join-Path $WikiSourcePath $SidebarFile
    Set-Content -Path $sidebarFilePath -Value $sidebar
}
