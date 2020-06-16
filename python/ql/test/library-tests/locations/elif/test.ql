import python

from AstNode ast, Location l
where ast.getLocation() = l
select ast.getAQlClass(), l.getStartLine(), l.getStartColumn(), l.getEndLine(), l.getEndColumn()
