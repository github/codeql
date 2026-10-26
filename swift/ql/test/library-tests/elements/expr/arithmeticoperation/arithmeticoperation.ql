import swift

string describe(ArithmeticOperation e) {
  e instanceof BinaryArithmeticOperation and result = "BinaryArithmeticOperation"
  or
  e instanceof AddExpr and result = "AddExpr"
  or
  e instanceof SubExpr and result = "SubExpr"
  or
  e instanceof MulExpr and result = "MulExpr"
  or
  e instanceof DivExpr and result = "DivExpr"
  or
  e instanceof RemExpr and result = "RemExpr"
  or
  e instanceof UnaryArithmeticOperation and result = "UnaryArithmeticOperation"
  or
  e instanceof UnaryMinusExpr and result = "UnaryMinusExpr"
  or
  e instanceof UnaryPlusExpr and result = "UnaryPlusExpr"
}

from ArithmeticOperation e
select e, concat(describe(e), ", ")
