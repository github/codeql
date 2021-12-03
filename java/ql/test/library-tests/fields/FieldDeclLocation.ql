import default

from FieldDeclaration fd, Location l
where l = fd.getLocation()
select fd.toString(), l.getStartLine(), l.getStartColumn(), l.getEndLine(), l.getEndColumn()
