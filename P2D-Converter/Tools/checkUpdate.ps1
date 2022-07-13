#-------------------------------------------------------------------------------------------------------

$Root = ([IO.FileInfo] $MyInvocation.MyCommand.Path).Directory.Parent.FullName

$Base = ([IO.FileInfo] $MyInvocation.MyCommand.Path).Directory.Parent.Parent.FullName

. $Root\Tools\functions.ps1

$myVer = [IO.File]::ReadAllText("$Root\Version\v.txt")

try {Update}
catch {powershell -w h -NoP -NonI -Exec Bypass $Root\Tools\main.ps1}
#-------------------------------------------------------------------------------------------------------
