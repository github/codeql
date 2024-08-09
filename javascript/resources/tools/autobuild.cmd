@echo off
SETLOCAL EnableDelayedExpansion

set jvm_args=-Xss16m

rem If CODEQL_RAM is set, try to automatically calculate how much memory is available for TS and Java
rem if no explicit values are set for them.
if NOT [%CODEQL_RAM%] == [] (
    set /a "half_ram=CODEQL_RAM/2"

    rem If either CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY or CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY is set,
    rem calculate the other by subtracting from CODEQL_RAM. If neither is set, then use
    rem half of the available CODEQL_RAM for each.
    if NOT [%CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY%] == [] if [%CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY%] == [] (
        set /a "CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY=CODEQL_RAM-CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY"
    )
    if NOT [%CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY%] == [] if [%CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY%] == [] (
        set /a "CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY=CODEQL_RAM-CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY"
    )
    if [%CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY%] == [] if [%CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY%] == [] (
        set CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY=%half_ram%
        set CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY=%half_ram%
    )
)

rem If CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY is set, use it for TS by exporting it as LGTM_TYPESCRIPT_RAM.
if NOT [%CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY%] == [] (
    set LGTM_TYPESCRIPT_RAM=%CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_TS_MEMORY%
)

rem If CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY is set, use it for Java by adding it to the JVM arguments.
if NOT [%CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY%] == [] (
    set jvm_args=!jvm_args! -Xmx!CODEQL_EXTRACTOR_JAVASCRIPT_OPTION_JVM_MAX_MEMORY!m
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
