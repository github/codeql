@echo off

set "RUST_BACKTRACE=full"
set "QLTEST_LOG=%CODEQL_EXTRACTOR_RUST_LOG_DIR%/qltest.log"

type NUL && "%CODEQL_EXTRACTOR_RUST_ROOT%/tools/%CODEQL_PLATFORM%/extractor" --qltest >"%QLTEST_LOG%" 2>&1

if %ERRORLEVEL% neq 0 (
    type "%QLTEST_LOG%"
    exit /b 1
)
