import python

from AstNode parent, AstNode child
where child.getParentNode() = parent
select parent.getLocation().getStartLine(), parent.toString(), child.getLocation().getStartLine(),
  child.toString()
