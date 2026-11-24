import rust

from Call c, string target
where
  c.getFile().getRelativePath() in [
      "first/src/lib.rs", "second/src/lib.rs", "src/lib.rs", "build.rs"
    ] and
  (
    target = c.getStaticTarget().getCanonicalPath()
    or
    not exists(c.getStaticTarget()) and target = "<unresolved>"
  )
select c, target
