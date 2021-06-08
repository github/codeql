**/mcs.exe:
**/csc.exe:
  invoke ${config_dir}/Semmle.Extraction.CSharp.Driver
  prepend --compiler
  prepend "${compiler}"
  prepend --cil
**/mono*:
**/dotnet:
  invoke ${config_dir}/extract-csharp.sh
**/msbuild:
**/xbuild:
  replace yes
  invoke ${compiler}
  append /p:UseSharedCompilation=false
