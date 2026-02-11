import utils.test.InlineExpectationsTest
import testModels

module InterpretElementTest implements TestSig {
  string getARelevantTag() { result = "interpretElement" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Element e |
      e = interpretElement(_, _, _, _, _, _) and
      location = e.getLocation() and
      element = e.toString() and
      tag = "interpretElement" and
      value = ""
    )
  }
}

import MakeTest<InterpretElementTest>
