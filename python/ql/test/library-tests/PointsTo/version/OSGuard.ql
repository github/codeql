
import python
import semmle.python.types.Version

from OsGuard og, Location l 
where l = og.getLastNode().getLocation() and
l.getFile().getName().matches("%test.py")
select l.getStartLine(), og.toString(), og.getOs()