@echo off

rem The autobuilder is already being traced
set CODEQL_AUTOBUILDER_CSHARP_NO_INDEXING=true

type NUL && "%CODEQL_EXTRACTOR_CSHARP_ROOT%/tools/%CODEQL_PLATFORM%/Semmle.Autobuild.CSharp.exe"
exit /b %ERRORLEVEL%
