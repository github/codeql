@echo off

type NUL && "%CODEQL_EXTRACTOR_GO_ROOT%/tools/%CODEQL_PLATFORM%/go-configure-baseline.exe"
exit /b %ERRORLEVEL%
