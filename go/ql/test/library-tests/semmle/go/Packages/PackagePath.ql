import go

from Package pkg, string fullpath
where
  packages(pkg, _, fullpath, _) and
  (
    pkg.getPath().contains("github.com/nonexistent-test-pkg")
    or
    pkg.getPath().startsWith("semmle.go.Packages")
  )
select pkg, pkg.getPath(), fullpath
