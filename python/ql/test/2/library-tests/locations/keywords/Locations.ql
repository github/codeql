import python

from Keyword k, Location l
where k.getLocation() = l
select l.getStartLine(), l.getStartColumn(), l.getEndLine(), l.getEndColumn()
