/**
 * @name Tests call graph.
 */

import csharp

from Callable src, Callable dest
where
  dest.fromSource() and
  src.calls(dest)
select src, dest, src.getDeclaringType()
