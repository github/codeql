import go
import utils.test.InlineExpectationsTest

module GotoTargetTest implements TestSig {
  string getARelevantTag() { result = "gotoTarget" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(GotoStmt jump, LabeledStmt target, ControlFlow::Node source |
      jump.getLocation() = location and
      source.getAstNode() = jump and
      source.getASuccessor().getAstNode() = target and
      element = jump.toString() and
      tag = "gotoTarget" and
      value = target.getLabel()
    )
  }
}

import MakeTest<GotoTargetTest>
