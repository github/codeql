import go

from CompositeLit c, int i, string s, Expr e
where
  s = "key" and e = c.getKey(i)
  or
  s = "value" and e = c.getValue(i)
select c, i, s, e
