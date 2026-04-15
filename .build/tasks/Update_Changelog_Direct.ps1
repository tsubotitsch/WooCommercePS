task Update_Changelog_Direct {
    . Set-SamplerTaskVariable

    Update-ChangelogDirect `
        -ModuleVersion $ModuleVersion `
        -ChangelogPath (Get-SamplerAbsolutePath -Path 'CHANGELOG.md' -RelativeTo $ProjectPath) `
        -GitHubToken ($env:GitHubToken ?? $env:GITHUB_TOKEN ?? '') `
        -GitUserName ($BuildInfo.GitHubConfig.GitHubConfigUserName ?? $env:GIT_USER_NAME ?? '') `
        -GitUserEmail ($BuildInfo.GitHubConfig.GitHubConfigUserEmail ?? $env:GIT_USER_EMAIL ?? '') `
        -UpdateChangelogOnPrerelease ([bool] $BuildInfo.GitHubConfig.UpdateChangelogOnPrerelease)
}
