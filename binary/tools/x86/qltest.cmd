@echo off

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files ^
    --prune=**/*.testproj ^
    --include-extension=.ps1 ^
    --size-limit=5m ^
    --language=powershell ^
    --working-dir=. ^
    "%CODEQL_EXTRACTOR_POWERSHELL_WIP_DATABASE%"

exit /b %ERRORLEVEL%
