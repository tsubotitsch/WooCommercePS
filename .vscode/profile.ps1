./build.ps1 -tasks minibuild
$version = dotnet-gitversion /showvariable MajorMinorPatch /nocache
$ModuleName = Get-SamplerProjectName -BuildRoot "."
$ModuleFile = ".\output\module\$ModuleName\$version\$ModuleName.psd1"
Import-Module $ModuleFile
