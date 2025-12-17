@echo off
setlocal enabledelayedexpansion

REM This script indexes PHP source files into the CodeQL database for testing on Windows
REM It uses the CodeQL CLI directly

if not defined CODEQL_DIST (
    echo Error: CODEQL_DIST not set 1>&2
    exit /b 1
)

if not defined CODEQL_EXTRACTOR_PHP_WIP_DATABASE (
    echo Error: CODEQL_EXTRACTOR_PHP_WIP_DATABASE not set 1>&2
    exit /b 1
)

set "WIP_DATABASE=%CODEQL_EXTRACTOR_PHP_WIP_DATABASE%"

REM Use the CodeQL CLI to index PHP files
"%CODEQL_DIST%\codeql.exe" database index-files ^
    --prune=**/*.test ^
    --include-extension=.php ^
    --include-extension=.php5 ^
    --include-extension=.php7 ^
    --size-limit=10m ^
    --language=php ^
    --working-dir=. ^
    "%WIP_DATABASE%"

exit /b %ERRORLEVEL%
