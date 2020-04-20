import go

from Package pkg, string mod, string path
where
  packages(pkg, _, package(mod, path), _) and
  mod = "PackageName" and
  path = "test"
select pkg, pkg.getPath()
