import python
private import LegacyPointsTo

from RaisingNode r, Scope s, ClassObject cls
where r.viableExceptionalExit_objectapi(s, cls)
select r.getLocation().getStartLine(), r.toString(), s.toString(), cls.toString()
