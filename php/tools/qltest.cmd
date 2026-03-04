@echo off

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files ^
    --prune=**/*.testproj ^
    --include-extension=.php ^
    --include-extension=.phtml ^
    --include-extension=.inc ^
    --size-limit=5m ^
    --language=php ^
    --working-dir=. ^
    "%CODEQL_EXTRACTOR_PHP_WIP_DATABASE%"

exit /b %ERRORLEVEL%
