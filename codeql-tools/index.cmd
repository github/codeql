@echo off
SETLOCAL EnableDelayedExpansion

type NUL && "%CODEQL_EXTRACTOR_GO_ROOT%/tools/%CODEQL_PLATFORM%/go-extractor.exe" -mod=vendor ./...
exit /b %ERRORLEVEL%

ENDLOCAL
