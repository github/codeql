import python

from RaisingNode r, Scope s, ClassObject cls
where r.viableExceptionalExit_objectapi(s, cls)
select r.getLocation().getStartLine(), r, s.toString(), cls
