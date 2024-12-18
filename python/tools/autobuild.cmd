@echo off

rem Legacy environment variables for the autobuild infrastructure.
set LGTM_SRC=%CD%
set LGTM_WORKSPACE=%CODEQL_EXTRACTOR_PYTHON_SCRATCH_DIR%

type NUL && python "%CODEQL_EXTRACTOR_PYTHON_ROOT%\tools\index.py"
exit /b %ERRORLEVEL%
