@echo off

if not defined CODEQL_POWERSHELL_EXTRACTOR (
    set CODEQL_POWERSHELL_EXTRACTOR=Semmle.Extraction.PowerShell.Standalone.exe
)

type NUL && "%CODEQL_EXTRACTOR_POWERSHELL_ROOT%/tools/%CODEQL_PLATFORM%/%CODEQL_POWERSHELL_EXTRACTOR%" ^
            --file-list "%1"

exit /b %ERRORLEVEL%