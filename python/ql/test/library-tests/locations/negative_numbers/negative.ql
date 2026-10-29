import python

from Expr e, int bl, int bc, int el, int ec, string p
where
  e.getLocation().hasLocationInfo(_, bl, bc, el, ec) and
  if e.isParenthesized() then p = "()" else p = ""
select e.toString(), bl, bc, el, ec, p
