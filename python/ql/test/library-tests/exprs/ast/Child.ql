import python

from AstNode p, AstNode c
where p.getAChildNode() = c
select p.getLocation().getStartLine(), p.toString(), c.getLocation().getStartLine(), c
