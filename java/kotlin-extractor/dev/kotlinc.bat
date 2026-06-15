@echo off

python "%~dp0wrapper.py" kotlinc %*
exit /b %ERRORLEVEL%
