@echo off

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files ^
    --include-extension=.ql ^
    --include-extension=.qll ^
    --size-limit=5m ^
    --language=ql ^
    "%CODEQL_EXTRACTOR_QL_WIP_DATABASE%"

exit /b %ERRORLEVEL%
