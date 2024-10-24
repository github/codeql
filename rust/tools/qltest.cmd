@echo off

set "RUST_BACKTRACE=full"

type NUL && "%CODEQL_EXTRACTOR_RUST_ROOT%/tools/%CODEQL_PLATFORM%/extractor" --qltest

exit /b %ERRORLEVEL%
