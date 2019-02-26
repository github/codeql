
import python
import semmle.python.types.Version

from VersionGuard vg, Location l, boolean b
where l = vg.getLastNode().getLocation()
and (if vg.isTrue() then b = true else b = false)
select l.getFile().getName(), l.getStartLine(), vg.toString(), b