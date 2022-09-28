import swift

string describe(LogicalOperation e) {
  e instanceof BinaryLogicalOperation and result = "BinaryLogicalExpr"
  or
  e instanceof LogicalAndExpr and result = "LogicalAndExpr"
  or
  e instanceof LogicalOrExpr and result = "LogicalOrExpr"
  or
  e instanceof UnaryLogicalOperation and result = "UnaryLogicalOperation"
  or
  e instanceof NotExpr and result = "NotExpr"
}

from LogicalOperation e
select e, concat(describe(e), ", ")
