
import python
import semmle.python.types.Version

from VersionGuard vg, Location l, int v
where l = vg.getLastNode().getLocation() and
l.getFile().getName().matches("%test.py")
and (if vg.isTrue() then v = major_version() else v = 5-major_version())
select l.getStartLine(), vg.toString(), v