import cpp

from Destructor f, Destructor g
where
  f.isCompilerGenerated() and
  f.calls(g) and
  not g.isCompilerGenerated()
select f, g
