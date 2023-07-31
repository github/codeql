@echo off
if exist vendor\modules.txt (
  type %CODEQL_EXTRACTOR_GO_ROOT%\tools\baseline-config-vendor.json
) else (
  type %CODEQL_EXTRACTOR_GO_ROOT%\tools\baseline-config-empty.json
)
