@echo off
setlocal enabledelayedexpansion

REM This script is invoked by CodeQL to extract PHP source files during database creation on Windows

REM Get the root of the PHP extractor pack (set by CodeQL)
if not defined CODEQL_EXTRACTOR_PHP_ROOT (
    for %%I in ("%~dp0..") do set "EXTRACTOR_ROOT=%%~fI"
) else (
    set "EXTRACTOR_ROOT=%CODEQL_EXTRACTOR_PHP_ROOT%"
)

set "EXTRACTOR_PLATFORM=%CODEQL_PLATFORM:win64=%"
if not defined CODEQL_PLATFORM set "EXTRACTOR_PLATFORM=win64"

REM The TRAP directory where extracted facts are written
if not defined CODEQL_EXTRACTOR_PHP_TRAP_DIR (
    echo Error: CODEQL_EXTRACTOR_PHP_TRAP_DIR not set 1>&2
    exit /b 1
)
set "TRAP_DIR=%CODEQL_EXTRACTOR_PHP_TRAP_DIR%"

REM Create TRAP directory if it doesn't exist
if not exist "%TRAP_DIR%" mkdir "%TRAP_DIR%"

REM Call the PHP extractor with the extract subcommand
REM %1 is the file list (path to a file containing paths of files to extract)
"%EXTRACTOR_ROOT%\tools\%EXTRACTOR_PLATFORM%\codeql-extractor-php.exe" extract ^
    --file-list "%1" ^
    --output-dir "%TRAP_DIR%"

exit /b %ERRORLEVEL%
