@echo off

type NUL && "%CODEQL_EXTRACTOR_CSHARP_ROOT%/tools/%CODEQL_PLATFORM%/Semmle.Autobuild.CSharp.exe"
exit /b %ERRORLEVEL%
