import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.implementation.raw.internal.TranslatedAssertion
import utils.test.InlineExpectationsTest

module Test implements TestSig {
  string getARelevantTag() { result = "var" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(TranslatedAssertionVarAccess tava, Variable v |
      v = tava.getVariable() and
      location = tava.getLocation() and
      tava.toString() = element and
      tag = "var" and
      value = v.getLocation().getStartLine().toString() + ":" + v.getName()
    )
  }
}

import MakeTest<Test>
