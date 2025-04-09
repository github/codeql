@echo off
rem All of the work is done in the PowerShell script
echo "Running PowerShell script at '%~dp0autobuild-impl.ps1'"
powershell.exe -File "%~dp0autobuild-impl.ps1"
