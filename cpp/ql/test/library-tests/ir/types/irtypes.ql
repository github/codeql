private import cpp
private import semmle.code.cpp.ir.implementation.raw.IR
import TestUtilities.InlineExpectationsTest

class IRTypesTest extends InlineExpectationsTest {
  IRTypesTest() { this = "IRTypesTest" }

  override string getARelevantTag() { result = "irtype" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(IRUserVariable irVar |
      location = irVar.getLocation() and
      element = irVar.toString() and
      tag = "irtype" and
      value = irVar.getIRType().toString()
    )
  }
}
