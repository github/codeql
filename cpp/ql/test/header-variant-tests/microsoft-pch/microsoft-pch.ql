import cpp

from ReturnStmt rs
select rs.getEnclosingFunction().getName(), ((Literal)rs.getExpr()).getValue()
