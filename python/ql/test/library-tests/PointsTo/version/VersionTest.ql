
import python
import semmle.python.types.Version

from VersionTest vt,  Location l, int v
where l = vt.getNode().getLocation() and
l.getFile().getName().matches("%test.py")
and (if vt.isTrue() then v = major_version() else v = 5-major_version())
select l.getStartLine(), vt.(ControlFlowNode).toString(), v
