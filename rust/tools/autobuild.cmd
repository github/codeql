@echo off

type NUL && "%CODEQL_EXTRACTOR_RUST_ROOT%\tools\%CODEQL_PLATFORM%\autobuild"

exit /b %ERRORLEVEL%
