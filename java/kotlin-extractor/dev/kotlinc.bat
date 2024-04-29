@echo off

python "%~dp0kotlinc" %*
exit /b %ERRORLEVEL%
