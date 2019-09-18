import python

from AstNode child, AstNode parent
where child.getParentNode() = parent
select child.getLocation().getStartLine(), child, parent.getLocation().getStartLine(), parent
