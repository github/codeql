@echo off

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files ^
    --prune=**/*.testproj ^
    --include-extension=.swift ^
    --include-extension=.swiftinterface ^
    --size-limit=5m ^
    --language=unified ^
    --working-dir=. ^
    "%CODEQL_EXTRACTOR_UNIFIED_WIP_DATABASE%"

IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

exit /b %ERRORLEVEL%
