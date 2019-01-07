import semmle.code.csharp.commons.Disposal
import csharp

from Variable v
where
  mayBeDisposed(v) and
  v.fromSource()
select v
