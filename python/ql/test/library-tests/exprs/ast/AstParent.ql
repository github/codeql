import python

select count(AstNode c | not exists(c.getParentNode()) and not c instanceof Module) +
    count(AstNode c | strictcount(c.getParentNode()) > 1)
