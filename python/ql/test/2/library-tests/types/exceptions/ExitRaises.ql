import python

from RaisingNode r, Scope s, ClassObject cls
where r.viableExceptionalExit(s, cls)

select r.getLocation().getStartLine(), r.toString(), s.toString(), cls.toString()
