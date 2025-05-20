import rust
import utils.test.InlineExpectationsTest

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
  op instanceof EqualOperation and result = "EqualOperation"
  or
  op instanceof NotEqualOperation and result = "NotEqualOperation"
  or
  op instanceof RelationalOperation and result = "RelationalOperation"
  or
  op instanceof LessThanOperation and result = "LessThanOperation"
  or
  op instanceof GreaterThanOperation and result = "GreaterThanOperation"
  or
  op instanceof LessOrEqualOperation and result = "LessOrEqualOperation"
  or
  op instanceof GreaterOrEqualOperation and result = "GreaterOrEqualOperation"
}

module OperationsTest implements TestSig {
  string getARelevantTag() {
    result = describe(_) or result = ["Op", "Operands", "Greater", "Lesser"]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Expr op |
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
