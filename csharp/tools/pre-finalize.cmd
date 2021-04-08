@echo off
SETLOCAL EnableDelayedExpansion

type NUL && "%CODEQL_DIST%\codeql" database index-files ^
    --include-extension=.config ^
    --include-extension=.csproj ^
    --include-extension=.props ^
    --include-extension=.xml ^
    --size-limit 10m ^
    --language xml ^
    -- ^
    "%CODEQL_EXTRACTOR_CSHARP_WIP_DATABASE%"

ENDLOCAL
