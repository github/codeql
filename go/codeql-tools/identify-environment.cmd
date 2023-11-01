@echo off
SETLOCAL EnableDelayedExpansion

type NUL && "%CODEQL_EXTRACTOR_GO_ROOT%/tools/%CODEQL_PLATFORM%/go-autobuilder.exe" --identify-environment

exit /b %ERRORLEVEL%

ENDLOCAL
