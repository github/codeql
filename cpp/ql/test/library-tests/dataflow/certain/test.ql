import cpp
import utils.test.InlineExpectationsTest
import semmle.code.cpp.dataflow.new.DataFlow::DataFlow

bindingset[s]
string quote(string s) { if s.matches("% %") then result = "\"" + s + "\"" else result = s }

module AsDefinitionTest implements TestSig {
  string getARelevantTag() { result = ["certain", "uncertain"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Ssa::Definition d |
      location = d.getLocation() and
      element = d.toString() and
      value = quote(d.toString())
    |
      if d.isCertain() then tag = "certain" else tag = "uncertain"
    )
  }
}

import MakeTest<AsDefinitionTest>
