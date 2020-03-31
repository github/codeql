import python

from AstNode a, Location l
where a.getLocation() = l
select l.getStartLine(), l.getStartColumn(), l.getEndLine(), l.getEndColumn(), a.toString()
