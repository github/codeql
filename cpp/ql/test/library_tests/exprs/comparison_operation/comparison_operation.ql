import cpp

from ComparisonOperation co, string s
where
  co instanceof EqualityOperation and s = "EqualityOperation"
  or
  co instanceof EQExpr and s = "EQExpr"
  or
  co instanceof NEExpr and s = "NEExpr"
  or
  co instanceof RelationalOperation and s = "RelationalOperation"
  or
  s = "getGreaterOperand() = " + co.(RelationalOperation).getGreaterOperand().toString()
  or
  s = "getLesserOperand() = " + co.(RelationalOperation).getLesserOperand().toString()
  or
  co instanceof GTExpr and s = "GTExpr"
  or
  co instanceof LTExpr and s = "LTExpr"
  or
  co instanceof GEExpr and s = "GEExpr"
  or
  co instanceof LEExpr and s = "LEExpr"
select co, s
