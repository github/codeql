import rust
import utils.test.InlineExpectationsTest
import TestUtils

string describe(Expr op) {
  op instanceof Operation and result = "Operation"
  or
  op instanceof PrefixExpr and result = "PrefixExpr"
  or
  op instanceof BinaryExpr and result = "BinaryExpr"
  or
  op instanceof AssignmentOperation and result = "AssignmentOperation"
  or
  op instanceof LogicalOperation and result = "LogicalOperation"
  or
  op instanceof RefExpr and result = "RefExpr"
  or
  op instanceof ComparisonOperation and result = "ComparisonOperation"
  or
  op instanceof EqualityOperation and result = "EqualityOperation"
  or
  op instanceof EqualsOperation and result = "EqualsOperation"
  or
  op instanceof NotEqualsOperation and result = "NotEqualsOperation"
  or
  op instanceof RelationalOperation and result = "RelationalOperation"
  or
  op instanceof LessThanOperation and result = "LessThanOperation"
  or
  op instanceof GreaterThanOperation and result = "GreaterThanOperation"
  or
  op instanceof LessOrEqualsOperation and result = "LessOrEqualsOperation"
  or
  op instanceof GreaterOrEqualsOperation and result = "GreaterOrEqualsOperation"
  or
  op instanceof ArithmeticOperation and result = "ArithmeticOperation"
  or
  op instanceof BinaryArithmeticOperation and result = "BinaryArithmeticOperation"
  or
  op instanceof AssignArithmeticOperation and result = "AssignArithmeticOperation"
  or
  op instanceof PrefixArithmeticOperation and result = "PrefixArithmeticOperation"
  or
  op instanceof BitwiseOperation and result = "BitwiseOperation"
  or
  op instanceof BinaryBitwiseOperation and result = "BinaryBitwiseOperation"
  or
  op instanceof AssignBitwiseOperation and result = "AssignBitwiseOperation"
  or
  op instanceof DerefExpr and result = "DerefExpr"
}

module OperationsTest implements TestSig {
  string getARelevantTag() {
    result = describe(_) or result = ["Op", "Operands", "Greater", "Lesser"]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Expr op |
      toBeTested(op) and
      location = op.getLocation() and
      location.getFile().getBaseName() != "" and
      element = op.toString() and
      (
        tag = describe(op) and
        value = ""
        or
        tag = "Op" and
        value = op.(Operation).getOperatorName()
        or
        op instanceof Operation and
        tag = "Operands" and
        value = count(op.(Operation).getAnOperand()).toString()
        or
        op instanceof RelationalOperation and
        tag = "Greater" and
        value = op.(RelationalOperation).getGreaterOperand().toString()
        or
        op instanceof RelationalOperation and
        tag = "Lesser" and
        value = op.(RelationalOperation).getLesserOperand().toString()
      )
    )
  }
}

import MakeTest<OperationsTest>
