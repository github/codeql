**/go-autobuilder:
  order compiler
  trace no
**/go:
  invoke ${config_dir}/go-extractor
  prepend --mimic
  prepend "${compiler}"
/usr/bin/codesign:
  replace yes
  invoke /usr/bin/env
  prepend /usr/bin/codesign
  trace no
/usr/bin/pkill:
  replace yes
  invoke /usr/bin/env
  prepend /usr/bin/pkill
  trace no
/usr/bin/pgrep:
  replace yes
  invoke /usr/bin/env
  prepend /usr/bin/pgrep
  trace no
