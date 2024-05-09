import python

from AstNode a, Location l
where l = a.getLocation()
select l.getStartLine(), l.getStartColumn(), l.getEndLine(), l.getEndColumn(), a.toString()
