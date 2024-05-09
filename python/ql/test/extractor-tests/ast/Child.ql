import python
import semmle.python.TestUtils

from AstNode p, AstNode c
where p.getAChildNode() = c
select compact_location(p), p.toString(), compact_location(c), c.toString()
