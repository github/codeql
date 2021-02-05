@echo off

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files ^
    --include-extension=.rb ^
    --include-extension=.erb ^
    --size-limit=5m ^
    --language=ruby ^
    "%CODEQL_EXTRACTOR_RUBY_WIP_DATABASE%"

exit /b %ERRORLEVEL%
