**/go-autobuilder.exe:
  order compiler
  trace no
**/go.exe:
  invoke ${config_dir}/go-extractor.exe
  prepend --mimic
  prepend "${compiler}"
