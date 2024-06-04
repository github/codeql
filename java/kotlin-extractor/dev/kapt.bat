@echo off

python "%~dp0wrapper.py" kapt %*
exit /b %ERRORLEVEL%
