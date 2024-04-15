@echo off

python "%~dp0/kotlinc" %*
exit /b %ERRORLEVEL%
