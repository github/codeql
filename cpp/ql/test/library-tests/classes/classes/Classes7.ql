import cpp

from Constructor f, Constructor g
where
  f.isCompilerGenerated() and
  f.calls(g) and
  not g.isCompilerGenerated()
select f, g
