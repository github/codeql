@echo off
SETLOCAL EnableDelayedExpansion

rem Some legacy environment variables for the autobuilder.
set LGTM_SRC=%CD%

if "%CODEQL_EXTRACTOR_GO_BUILD_TRACING%"=="on" if not "%CODEQL_EXTRACTOR_GO_BUILD_MODE%"=="none" (
  echo "Tracing enabled"
  type NUL && "%CODEQL_EXTRACTOR_GO_ROOT%/tools/%CODEQL_PLATFORM%/go-build-runner.exe"
  exit /b !ERRORLEVEL!
)
type NUL && "%CODEQL_EXTRACTOR_GO_ROOT%/tools/%CODEQL_PLATFORM%/go-autobuilder.exe"
exit /b %ERRORLEVEL%

ENDLOCAL
