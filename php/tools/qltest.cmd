@echo off

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files ^
    --prune=**/*.testproj ^
    --include-extension=.php ^
    --exclude=**/.git ^
    --size-limit=5m ^
    --language=php ^
    --working-dir=. ^
    "%CODEQL_EXTRACTOR_PHP_WIP_DATABASE%"

exit /b %ERRORLEVEL%
