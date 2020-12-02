import cpp

from Type t, VlaDeclStmt d, int i, VlaDimensionStmt s
where
  t = d.getType() and
  s = d.getVlaDimensionStmt(i)
select t, d, i, s, s.getDimensionExpr()
