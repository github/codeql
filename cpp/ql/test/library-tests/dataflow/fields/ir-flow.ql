/**
 * @kind problem
 */

import TestUtilities.InlineExpectationsTest
import semmle.code.cpp.ir.dataflow.DataFlow
import IRConfiguration
import cpp

class IRFieldFlowTest extends InlineExpectationsTest {
  IRFieldFlowTest() { this = "IRFieldFlowTest" }

  override string getARelevantTag() { result = "ir" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node source, DataFlow::Node sink, Conf conf, int n |
      tag = "ir" and
      conf.hasFlow(source, sink) and
      n = strictcount(DataFlow::Node otherSource | conf.hasFlow(otherSource, sink)) and
      (
        n = 1 and value = ""
        or
        // If there is more than one source for this sink
        // we specify the source location explicitly.
        n > 1 and
        value =
          source.getLocation().getStartLine().toString() + ":" +
            source.getLocation().getStartColumn()
      ) and
      location = sink.getLocation() and
      element = sink.toString()
    )
  }
}
