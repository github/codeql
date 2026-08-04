import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import utils.test.InlineExpectationsTest

private module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CallCfgNode).getFunction().asCfgNode().(NameNode).getId() = "source"
  }

  predicate isSink(DataFlow::Node node) {
    exists(DataFlow::CallCfgNode call |
      call.getFunction().asCfgNode().(NameNode).getId() = "sink" and
      node = call.getArg(0)
    )
  }
}

private module TestFlow = TaintTracking::Global<TestConfig>;

module FlowTest implements TestSig {
  string getARelevantTag() { result = "flow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node sink |
      TestFlow::flow(_, sink) and
      tag = "flow" and
      location = sink.getLocation() and
      value = "source" and
      element = sink.toString()
    )
  }
}

import MakeTest<FlowTest>
