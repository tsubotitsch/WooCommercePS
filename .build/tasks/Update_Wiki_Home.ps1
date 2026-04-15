task Update_Wiki_Home {
    $error.Clear()
    Write-Output "TS: Update_Wiki_Home"
    $readmePath = Join-Path (Get-SamplerAbsolutePath) "README.md"
    $homePath = Join-Path $OutputDirectory "WikiContent/Home.md"
    $footerPath = Join-Path $OutputDirectory "WikiContent/_Footer.md"
    $version = & dotnet-gitversion /showvariable SemVer
    $date = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"

    if (Test-Path $readmePath)
    {
        # Ensure the output directory exists
        $wikiDir = Split-Path $homePath
        if (-not (Test-Path $wikiDir))
        {
            New-Item -ItemType Directory -Force -Path $wikiDir | Out-Null
        }

        Get-Content $readmePath | Out-File $homePath -Encoding UTF8

        $footerLines = @(
            "**Last updated:** $date",
            "**Version:** $version",
            ""
        )
        $footerLines | Out-File $footerPath -Encoding UTF8

        Write-Output "Updated Home.md and _Footer.md with version $version and date $date"
    }
    else
    {
        Write-Warning "README.md not found at $readmePath"
    }
    Get-Error | Out-String | Write-Host -ForegroundColor Yellow
}
