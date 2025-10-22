@echo off

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files --working-dir=. --language=binary --include-extension=.exe --include-extension=.dll "%CODEQL_EXTRACTOR_BINARY_WIP_DATABASE%"
exit /b %ERRORLEVEL%
