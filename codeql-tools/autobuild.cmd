@echo off
SETLOCAL EnableDelayedExpansion

rem Some legacy environment variables for the autobuilder.
set LGTM_SRC=%CD%

if "%CODEQL_EXTRACTOR_GO_BUILD_TRACING%"=="on" (
  echo "Tracing enabled"
  type NUL && "%CODEQL_EXTRACTOR_GO_ROOT%/tools/%CODEQL_PLATFORM%/go-build-runner.exe"
) else (
  type NUL && "%CODEQL_EXTRACTOR_GO_ROOT%/tools/%CODEQL_PLATFORM%/go-autobuilder.exe"
)
exit /b %ERRORLEVEL%

ENDLOCAL
