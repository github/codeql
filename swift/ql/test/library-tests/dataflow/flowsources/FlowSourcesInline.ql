import swift
import TestUtilities.InlineExpectationsTest
import FlowConfig
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.DataFlow

module TaintReachConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof FlowSource }

  predicate isSink(DataFlow::Node sink) { any() }
}

module TaintReachFlow = TaintTracking::Global<TaintReachConfiguration>;

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
  }

  predicate hasOptionalResult(Location location, string element, string tag, string value) {
    // this is not really what the "flowsources" test is about, but sometimes it's helpful to
    // confirm that taint reaches certain obvious points in the flow source test code.
    exists(DataFlow::Node n |
      TaintReachFlow::flowTo(n) and
      location = n.getLocation() and
      location.getFile().getBaseName() != "" and
      element = n.toString() and
      tag = "tainted" and
      value = ""
    )
  }
}

import MakeTest<FlowSourcesTest>
