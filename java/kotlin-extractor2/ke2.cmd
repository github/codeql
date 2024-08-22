@echo off

IF [%CODEQL_JAVA_HOME] == [] (
  set JAVA=java.exe
) else (
  set JAVA=%CODEQL_JAVA_HOME\bin\java.exe
)

%JAVA -cp %~dp0ke2_deploy.jar KotlinExtractorKt %*
exit /b %ERRORLEVEL%
