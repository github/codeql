import cpp

from ReturnStmt rs
select rs.getEnclosingFunction().getName(), rs.getExpr().(Literal).getValue()
