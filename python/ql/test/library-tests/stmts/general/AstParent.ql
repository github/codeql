import python

/* The result of this query should always be 0, *regardless* of the database. */
select count(AstNode c | not exists(c.getParentNode()) and not c instanceof Module) +
    count(AstNode c | strictcount(c.getParentNode()) > 1)
