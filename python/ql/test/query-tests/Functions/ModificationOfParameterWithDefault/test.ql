import python
import semmle.python.dataflow.new.DataFlow
import utils.test.InlineExpectationsTest
import semmle.python.functions.ModificationOfParameterWithDefault
private import semmle.python.dataflow.new.internal.PrintNode

module ModificationOfParameterWithDefaultTest implements TestSig {
  string getARelevantTag() { result = "modification" }

  private predicate relevant_node(DataFlow::Node sink) {
    ModificationOfParameterWithDefault::Flow::flowTo(sink)
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node n | relevant_node(n) |
      n.getLocation() = location and
      tag = "modification" and
      value = prettyNode(n) and
      element = n.toString()
    )
  }
}

import MakeTest<ModificationOfParameterWithDefaultTest>
