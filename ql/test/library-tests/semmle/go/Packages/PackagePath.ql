import go

from Package pkg
where
  pkg.getPath().matches("%github.com/nonexistent-test-pkg%")
  or
  pkg.getPath().matches("semmle.go.Packages%")
select pkg, pkg.getPath()
