import default

from Field f, Location l
where f.fromSource() and l = f.getLocation()
select f, l.getStartLine(), l.getStartColumn(), l.getEndLine(), l.getEndColumn()
