@echo off

CALL "%CODEQL_EXTRACTOR_RUBY_ROOT%\tools\autobuild.cmd"

exit /b %ERRORLEVEL%
