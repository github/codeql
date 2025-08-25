@echo off

type NUL && "%CODEQL_EXTRACTOR_RUST_ROOT%\tools\%CODEQL_PLATFORM%\extractor" @"%1"

exit /b %ERRORLEVEL%
