#-------------------------------------------------------------------------------------------------------

$Root = ([IO.FileInfo] $MyInvocation.MyCommand.Path).Directory.Parent.FullName

$Base = ([IO.FileInfo] $MyInvocation.MyCommand.Path).Directory.Parent.Parent.FullName

. $Root\Tools\functions.ps1

$myVer = [IO.File]::ReadAllText("$Root\Version\v.txt")

Update
#-------------------------------------------------------------------------------------------------------
