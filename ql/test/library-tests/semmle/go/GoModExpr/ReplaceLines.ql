import go

from GoModReplaceLine repl, string origVersion, string repVersion
where
  (
    repVersion = repl.getReplacementVersion()
    or
    not exists(repl.getReplacementVersion()) and
    repVersion = "no version"
  ) and
  (
    origVersion = repl.getOriginalVersion()
    or
    not exists(repl.getOriginalVersion()) and
    origVersion = "no version"
  )
select repl, repl.getModulePath(), repl.getOriginalPath(), origVersion, repl.getReplacementPath(),
  repVersion
