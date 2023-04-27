import swift

string describe(BitwiseOperation e) {
  e instanceof BinaryBitwiseOperation and result = "BinaryBitwiseOperation"
  or
  e instanceof AndBitwiseExpr and result = "AndBitwiseExpr"
  or
  e instanceof OrBitwiseExpr and result = "OrBitwiseExpr"
  or
  e instanceof XorBitwiseExpr and result = "XorBitwiseExpr"
  or
  e instanceof PointwiseAndExpr and result = "PointwiseAndExpr"
  or
  e instanceof PointwiseOrExpr and result = "PointwiseOrExpr"
  or
  e instanceof PointwiseXorExpr and result = "PointwiseXorExpr"
  or
  e instanceof ShiftLeftBitwiseExpr and result = "ShiftLeftBitwiseExpr"
  or
  e instanceof ShiftRightBitwiseExpr and result = "ShiftRightBitwiseExpr"
  or
  e instanceof UnaryBitwiseOperation and result = "UnaryBitwiseOperation"
  or
  e instanceof NotBitwiseExpr and result = "NotBitwiseExpr"
}

from BitwiseOperation e
select e, concat(describe(e), ", ")
