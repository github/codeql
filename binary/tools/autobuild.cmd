@echo off

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files --working-dir=. --language=binary --include-extension=.exe "%CODEQL_EXTRACTOR_BINARY_WIP_DATABASE%"
exit /b %ERRORLEVEL%
