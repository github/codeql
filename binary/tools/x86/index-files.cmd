@echo off

if not defined CODEQL_BINARY_EXTRACTOR (
    set CODEQL_BINARY_EXTRACTOR=extractor.exe
)

type NUL && "%CODEQL_EXTRACTOR_BINARY_ROOT%/tools/%CODEQL_PLATFORM%/%CODEQL_BINARY_EXTRACTOR%" --file-list "%1"

exit /b %ERRORLEVEL%