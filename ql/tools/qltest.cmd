@echo off

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files ^
    --prune=**/*.testproj ^
    --include-extension=.ql ^
    --include-extension=.qll ^
    --include-extension=.dbscheme ^
    --include-extension=.yml ^
    --size-limit=5m ^
    --language=ql ^
    --working-dir=. ^
    "%CODEQL_EXTRACTOR_QL_WIP_DATABASE%"

IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files ^
    --prune=**/*.testproj ^
    --include-extension=.yml ^
    --size-limit=5m ^
    --language=yaml ^
    --working-dir=. ^
    "%CODEQL_EXTRACTOR_QL_WIP_DATABASE%"

exit /b %ERRORLEVEL%

