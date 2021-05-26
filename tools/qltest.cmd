@echo off

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files ^
    --prune=**/*.testproj ^
    --include-extension=.rb ^
    --include-extension=.erb ^
    --size-limit=5m ^
    --language=ql ^
    "%CODEQL_EXTRACTOR_QL_WIP_DATABASE%"

exit /b %ERRORLEVEL%
