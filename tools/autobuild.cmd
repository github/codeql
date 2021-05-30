@echo off

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files ^
    --include-extension=.ql ^
    --include-extension=.qll ^
    --include-extension=.dbscheme ^
    --include=**/qlpack.yml ^
    --size-limit=5m ^
    --language=ql ^
    "%CODEQL_EXTRACTOR_QL_WIP_DATABASE%"

exit /b %ERRORLEVEL%
