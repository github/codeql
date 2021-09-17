**\fakes*.exe:
**\moles*.exe:
  order compiler
  trace no
**\csc*.exe:
  invoke ${config_dir}\Semmle.Extraction.CSharp.Driver.exe
  prepend --compiler
  prepend "${compiler}"
  prepend --cil
**\dotnet.exe:
  invoke ${config_dir}\Semmle.Extraction.CSharp.Driver.exe
  prepend --dotnetexec
  prepend --cil
