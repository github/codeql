import go

from Package pkg, string fullpath
where
  packages(pkg, _, fullpath, _) and
  (
    pkg.getPath().matches("%github.com/nonexistent-test-pkg%")
    or
    pkg.getPath().matches("semmle.go.Packages%")
  )
select pkg, pkg.getPath(), fullpath
