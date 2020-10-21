@echo off

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files ^
    --include-extension=.rb ^
    --size-limit=5m ^
    --language=ruby ^
    "%CODEQL_EXTRACTOR_RUBY_WIP_DATABASE%"

exit /b %ERRORLEVEL%
