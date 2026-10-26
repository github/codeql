import swift
import utils.test.InlineExpectationsTest
import FlowConfig
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.DataFlow

module TestConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof FlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(CallExpr sinkCall |
      sinkCall.getStaticTarget().getName().matches("sink%") and
      sinkCall.getAnArgument().getExpr() = sink.asExpr()
    )
  }
}

module TestFlow = TaintTracking::Global<TestConfiguration>;

string describe(FlowSource source) {
  source instanceof RemoteFlowSource and result = "remote"
  or
  source instanceof LocalFlowSource and result = "local"
}

module FlowSourcesTest implements TestSig {
  string getARelevantTag() { result = ["source", "tainted"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(FlowSource source |
      location = source.getLocation() and
      location.getFile().getBaseName() != "" and
      element = source.toString() and
      tag = "source" and
      value = describe(source)
    )
    or
    exists(DataFlow::Node sink |
      // this is not really what the "flowsources" test is about, but sometimes it's helpful to
      // have sinks and confirm that taint reaches obvious points in the flow source test code.
      TestFlow::flowTo(sink) and
      location = sink.getLocation() and
      element = sink.toString() and
      tag = "tainted" and
      value = ""
    )
  }
}

import MakeTest<FlowSourcesTest>
