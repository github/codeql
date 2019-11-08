@echo off
SETLOCAL EnableDelayedExpansion

rem Some legacy environment variables for the autobuilder.
set LGTM_SRC=%CD%

type NUL && "%CODEQL_EXTRACTOR_GO_ROOT%/tools/%CODEQL_PLATFORM%/go-autobuilder.exe"
exit /b %ERRORLEVEL%

ENDLOCAL
