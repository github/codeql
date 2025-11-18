@echo off
setlocal enabledelayedexpansion

if "%CODEQL_EXTRACTOR_CSHARPIL_ROOT%"=="" (
  for %%i in ("%~dp0..") do set "CODEQL_EXTRACTOR_CSHARPIL_ROOT=%%~fi"
)

set "TRAP_DIR=%CODEQL_EXTRACTOR_CSHARPIL_TRAP_DIR%"

echo C# IL Extractor: Starting extraction
echo Source root: %CD%
echo TRAP directory: %TRAP_DIR%

set "EXTRACTOR_PATH=%CODEQL_EXTRACTOR_CSHARPIL_ROOT%\extractor\Semmle.Extraction.CSharp.IL\bin\Debug\net8.0\Semmle.Extraction.CSharp.IL.exe"

if not exist "%EXTRACTOR_PATH%" (
  echo ERROR: Extractor not found at %EXTRACTOR_PATH%
  echo Please build the extractor first with: dotnet build extractor\Semmle.Extraction.CSharp.IL
  exit /b 1
)

set FILE_COUNT=0

for /r %%f in (*.dll *.exe) do (
  echo Extracting: %%f
  
  set "ASSEMBLY_PATH=%%f"
  set "TRAP_NAME=!ASSEMBLY_PATH:\=_!"
  set "TRAP_NAME=!TRAP_NAME:/=_!"
  set "TRAP_NAME=!TRAP_NAME::=_!"
  set "TRAP_FILE=%TRAP_DIR%\!TRAP_NAME!.trap"
  
  "%EXTRACTOR_PATH%" "%%f" "!TRAP_FILE!" || echo Warning: Failed to extract %%f
  
  set /a FILE_COUNT+=1
)

echo C# IL Extractor: Completed extraction of %FILE_COUNT% assemblies
exit /b 0
