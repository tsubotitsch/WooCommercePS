./build.ps1 -tasks minibuild
$version = dotnet-gitversion /showvariable MajorMinorPatch /nocache
$ModuleFile = ".\output\module\SendDrop\$version\SendDrop.psd1"
Import-Module $ModuleFile
