@echo off

"%CODEQL_DIST%\codeql.exe" database index-files --working-dir=. --language=cil "%CODEQL_EXTRACTOR_CIL_WIP_DATABASE%"
exit /b %ERRORLEVEL%