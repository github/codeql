import python

from Class cls, Location l
where l = cls.getLocation()
select cls.getName(), l.getStartLine(), l.getStartColumn(), l.getEndLine(), l.getEndColumn()
