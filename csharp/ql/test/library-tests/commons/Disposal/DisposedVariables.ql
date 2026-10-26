import semmle.code.csharp.commons.Disposal

from Variable v
where
  mayBeDisposed(v) and
  v.fromSource()
select v
