import cpp

from Handler h, string property, Element value
where
  property = "getParameter" and value = h.getParameter()
  or
  property = "getBlock" and value = h.getBlock()
  or
  property = "getTryStmt" and value = h.getTryStmt()
  or
  property = "getTryStmt.getACatchClause()" and value = h.getTryStmt().getACatchClause()
select h, property, value
