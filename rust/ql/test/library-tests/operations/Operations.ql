import rust
import utils.test.InlineExpectationsTest

string describe(Expr op) {
  op instanceof PrefixExpr and result = "PrefixExpr"
  or
  op instanceof BinaryExpr and result = "BinaryExpr"
  or
  op instanceof AssignmentOperation and result = "AssignmentOperation"
  or
  op instanceof LogicalOperation and result = "LogicalOperation"
  or
  op instanceof RefExpr and result = "RefExpr"
}

module OperationsTest implements TestSig {
  string getARelevantTag() { result = describe(_) }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Expr op |
      location = op.getLocation() and
      location.getFile().getBaseName() != "" and
      element = op.toString() and
      tag = describe(op) and
      value = ""
    )
  }
}

import MakeTest<OperationsTest>
