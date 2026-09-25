import go
import utils.test.InlineExpectationsTest

module GotoTargetTest implements TestSig {
  string getARelevantTag() { result = "gotoTarget" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(GotoStmt jump, LabeledStmt target |
      jump.getLocation() = location and
      jump.getLabel() = target.getLabel() and
      target.getStmt().getFirstControlFlowNode() = jump.getFirstControlFlowNode().getASuccessor+() and
      element = jump.toString() and
      tag = "gotoTarget" and
      value = target.getLabel()
    )
  }
}

import MakeTest<GotoTargetTest>
