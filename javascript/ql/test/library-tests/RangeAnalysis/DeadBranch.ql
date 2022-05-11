import javascript

class AssertionComment extends LineComment {
  boolean isOK;

  AssertionComment() {
    isOK = true and this.getText().trim().matches("OK%")
    or
    isOK = false and this.getText().trim().matches("NOT OK%")
  }

  ConditionGuardNode getAGuardNode() {
    result.getLocation().getStartLine() = this.getLocation().getStartLine() and
    result.getFile() = this.getFile()
  }

  Expr getTestExpr() { result = this.getAGuardNode().getTest() }

  string getMessage() {
    not exists(this.getAGuardNode()) and result = "Error: no guard node on this line"
    or
    isOK = true and
    exists(ConditionGuardNode guard | guard = this.getAGuardNode() |
      RangeAnalysis::isContradictoryGuardNode(guard) and
      result =
        "Error: analysis claims " + this.getTestExpr() + " is always " +
          guard.getOutcome().booleanNot()
    )
    or
    isOK = false and
    not RangeAnalysis::isContradictoryGuardNode(this.getAGuardNode()) and
    result = "Error: " + this.getTestExpr() + " is always true or always false"
  }
}

from AssertionComment assertion
select assertion, assertion.getMessage()
