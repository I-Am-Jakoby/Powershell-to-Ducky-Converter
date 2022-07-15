@ECHO OFF

Pushd "%~dp0"
powershell -file Tools\checkUpdate.ps1
popd


