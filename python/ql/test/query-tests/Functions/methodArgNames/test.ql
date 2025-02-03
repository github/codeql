import python
import Functions.MethodArgNames
import utils.test.InlineExpectationsTest

module MethodArgTest implements TestSig {
  string getARelevantTag() { result = ["shouldBeSelf", "shouldBeCls"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Function f |
      element = f.toString() and
      location = f.getLocation() and
      value = "" and
      (
        firstArgShouldBeNamedSelfAndIsnt(f) and
        tag = "shouldBeSelf"
        or
        firstArgShouldBeNamedClsAndIsnt(f) and
        tag = "shouldBeCls"
      )
    )
  }
}

import MakeTest<MethodArgTest>
