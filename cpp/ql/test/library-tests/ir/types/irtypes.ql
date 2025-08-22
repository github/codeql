private import cpp
private import semmle.code.cpp.ir.implementation.raw.IR
import utils.test.InlineExpectationsTest

module IRTypesTest implements TestSig {
  string getARelevantTag() { result = "irtype" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(IRUserVariable irVar |
      location = irVar.getLocation() and
      element = irVar.toString() and
      tag = "irtype" and
      value = irVar.getIRType().toString()
    )
  }
}

import MakeTest<IRTypesTest>
