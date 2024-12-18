@echo off
SETLOCAL EnableDelayedExpansion

set jvm_args=-Xss16m

rem If CODEQL_RAM is set, use half for Java and half for TS.
if NOT [%CODEQL_RAM%] == [] (
    set /a "half_ram=CODEQL_RAM/2"
    set LGTM_TYPESCRIPT_RAM=!half_ram!
    set jvm_args=!jvm_args! -Xmx!half_ram!m
)

rem If CODEQL_THREADS is set, propagate via LGTM_THREADS.
if NOT [%CODEQL_THREADS%] == [] (
    set LGTM_THREADS=%CODEQL_THREADS%
)

rem The JS autobuilder expects to find typescript modules under SEMMLE_DIST/tools.
rem They are included in the pack, but we need to set SEMMLE_DIST appropriately.
set SEMMLE_DIST=%CODEQL_EXTRACTOR_JAVASCRIPT_ROOT%

rem The JS autobuilder expects LGTM_SRC to be set to the source root.
set LGTM_SRC=%CD%

type NUL && "%CODEQL_JAVA_HOME%\bin\java.exe" %jvm_args% ^
    -cp "%CODEQL_EXTRACTOR_JAVASCRIPT_ROOT%\tools\extractor-javascript.jar" ^
    com.semmle.js.extractor.AutoBuild
exit /b %ERRORLEVEL%

ENDLOCAL
