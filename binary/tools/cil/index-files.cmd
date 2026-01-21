@echo off

if not defined CODEQL_CIL_EXTRACTOR (
    set CODEQL_CIL_EXTRACTOR=Semmle.Extraction.CSharp.IL.exe
)

type NUL && "%CODEQL_EXTRACTOR_CIL_ROOT%/tools/%CODEQL_PLATFORM%/%CODEQL_CIL_EXTRACTOR%" "%1"
exit /b %ERRORLEVEL%