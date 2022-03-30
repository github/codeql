import cpp

from Variable v, VlaDeclStmt d, int i, VlaDimensionStmt s
where
  v = d.getVariable() and
  s = d.getVlaDimensionStmt(i)
select v, d, i, s, s.getDimensionExpr()
