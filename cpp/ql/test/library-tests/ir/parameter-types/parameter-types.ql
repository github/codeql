private import cpp
private import semmle.code.cpp.ir.IR
import utils.test.InlineExpectationsTest

module ParameterTypesTest implements TestSig {
  string getARelevantTag() { result = "type" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(VariableAddressInstruction va, InitializeParameterInstruction init |
      init.getAnOperand().getDef() = va and
      location = va.getLocation() and
      element = va.toString() and
      tag = "type" and
      value = "\"" + va.getResultLanguageType().toString() + "\""
    )
  }
}

import MakeTest<ParameterTypesTest>
