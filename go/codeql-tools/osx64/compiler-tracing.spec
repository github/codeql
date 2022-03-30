**/go-autobuilder:
  order compiler
  trace no
**/go:
  invoke ${config_dir}/go-extractor
  prepend --mimic
  prepend "${compiler}"
