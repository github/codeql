@echo off

python "%~dp0wrapper.py" kotlin %*
exit /b %ERRORLEVEL%
