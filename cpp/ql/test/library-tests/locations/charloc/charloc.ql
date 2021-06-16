import cpp

from File f, Expr e, Location l, int start, int end
where
  e.getLocation() = l and
  l.charLoc(f, start, end)
select f.getBaseName(), e.toString(), start, end,
  concat(Expr e2, Location l2 | e2.getLocation() = l2 and l.subsumes(l2) | e2.toString(), ", ")
