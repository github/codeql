/**
 * @kind path-problem
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import utils.test.dataflow.testConfig
import utils.test.InlineExpectationsTest

module TestTaintFlow = TaintTracking::Global<TestConfig>;

module PathNodeTest implements TestSig {
  string getARelevantTag() { result = "path-node" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(TestTaintFlow::PathNode pn |
      location = pn.getNode().getLocation() and
      tag = "path-node" and
      value = "" and
      element = pn.toString()
    )
  }
}

import MakeTest<PathNodeTest>
// running the query to inspect the results can be quite nice!
// just uncomment these lines!
// import TestTaintFlow::PathGraph
// from TestTaintFlow::PathNode source, TestTaintFlow::PathNode sink
// where TestTaintFlow::flowPath(source, sink)
// select sink.getNode(), source, sink,
//   sink.getNode().getEnclosingCallable().toString() + ": --> " +
//     sink.getNode().getLocation().getStartLine().toString()
