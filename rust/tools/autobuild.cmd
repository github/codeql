@echo off

type NUL && "%CODEQL_DIST%\codeql.exe" database index-files --working-dir=. --language=rust --include-extension=.rs "%CODEQL_EXTRACTOR_RUST_WIP_DATABASE%"

exit /b %ERRORLEVEL%
