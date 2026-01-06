@echo off

"%CODEQL_EXTRACTOR_JVM_ROOT%/tools/%CODEQL_PLATFORM%/Semmle.Extraction.Java.ByteCode.exe" "%1"
exit /b %ERRORLEVEL%
