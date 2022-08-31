**/mcs.exe:
**/csc.exe:
  invoke ${config_dir}/Semmle.Extraction.CSharp.Driver
  prepend --compiler
  prepend "${compiler}"
**/mono*:
**/dotnet:
  invoke ${config_dir}/Semmle.Extraction.CSharp.Driver
  prepend --dotnetexec
**/msbuild:
**/xbuild:
  replace yes
  invoke ${compiler}
  append /p:UseSharedCompilation=false
