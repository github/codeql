@echo off
REM For C# IL, autobuild and buildless extraction are the same - just extract the DLLs
call "%~dp0index.cmd"
exit /b %ERRORLEVEL%
