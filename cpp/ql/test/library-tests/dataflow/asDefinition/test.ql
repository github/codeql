import cpp
import utils.test.InlineExpectationsTest
import semmle.code.cpp.dataflow.new.DataFlow::DataFlow

bindingset[s]
string quote(string s) { if s.matches("% %") then result = "\"" + s + "\"" else result = s }

module AsDefinitionTest implements TestSig {
  string getARelevantTag() { result = "asDefinition" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Node n, Expr e |
      e = n.asDefinition() and
      location = e.getLocation() and
      element = n.toString() and
      tag = "asDefinition" and
      value = quote(e.toString())
    )
  }
}

import MakeTest<AsDefinitionTest>
