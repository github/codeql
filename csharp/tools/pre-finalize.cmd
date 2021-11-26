@echo off

type NUL && "%CODEQL_DIST%\codeql" database index-files ^
    --include-extension=.config ^
    --include-extension=.csproj ^
    --include-extension=.props ^
    --include-extension=.xml ^
    --size-limit 10m ^
    --language xml ^
    -- ^
    "%CODEQL_EXTRACTOR_CSHARP_WIP_DATABASE%" ^
    >nul 2>&1
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

type NUL && "%CODEQL_JAVA_HOME%\bin\java.exe" -jar "%CODEQL_EXTRACTOR_CSHARP_ROOT%\tools\extractor-asp.jar" .
exit /b %ERRORLEVEL%
