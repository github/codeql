import cpp
private import utils.test.InlineExpectationsTest
private import semmle.code.cpp.ir.IR

module VariableAddressTest implements TestSig {
  string getARelevantTag() { result = "VariableAddress" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(VariableAddressInstruction vai |
      not vai.getAst() instanceof DeclarationEntry and
      not vai.getAst() instanceof Parameter and
      tag = "VariableAddress" and
      value = vai.getAstVariable().getName() and
      element = vai.toString() and
      location = vai.getLocation()
    )
  }
}

import MakeTest<VariableAddressTest>
