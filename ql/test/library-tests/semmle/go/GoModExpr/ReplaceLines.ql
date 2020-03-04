import go

from GoModReplaceLine repl, GoModModuleLine mod, string repVer
where
  repl.getFile() = mod.getFile() and
  (
    repVer = repl.getReplacementVer() or
    repVer = "no version"
  )
select repl, mod.getPath(), repl.getOriginalPath(), repl.getReplacementPath(),
  repl.getReplacementVer()
