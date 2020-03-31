import javascript

class AssertionComment extends LineComment {
  boolean isOK;

  AssertionComment() {
    isOK = true and getText().trim().regexpMatch("OK.*")
    or
    isOK = false and getText().trim().regexpMatch("NOT OK.*")
  }

  ConditionGuardNode getAGuardNode() {
    result.getLocation().getStartLine() = this.getLocation().getStartLine() and
    result.getFile() = this.getFile()
  }

  Expr getTestExpr() { result = getAGuardNode().getTest() }

  string getMessage() {
    not exists(getAGuardNode()) and result = "Error: no guard node on this line"
    or
    isOK = true and
    exists(ConditionGuardNode guard | guard = getAGuardNode() |
      RangeAnalysis::isContradictoryGuardNode(guard) and
      result =
        "Error: analysis claims " + getTestExpr() + " is always " + guard.getOutcome().booleanNot()
    )
    or
    isOK = false and
    not RangeAnalysis::isContradictoryGuardNode(getAGuardNode()) and
    result = "Error: " + getTestExpr() + " is always true or always false"
  }
}

from AssertionComment assertion
select assertion, assertion.getMessage()
