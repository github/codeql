import java
import semmle.code.java.dataflow.DataFlow
import utils.test.InlineExpectationsTest

module Base {
  predicate isSource(DataFlow::Node n) { n.asExpr().(MethodCall).getMethod().hasName("source") }

  predicate isSink(DataFlow::Node n) {
    exists(MethodCall ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

module ConfigSourceCc implements DataFlow::ConfigSig {
  import Base

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }
}

module ConfigSinkCc implements DataFlow::ConfigSig {
  import Base

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSinkCallContext }
}

module ConfigEqualCc implements DataFlow::ConfigSig {
  import Base

  DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureEqualSourceSinkCallContext
  }
}

module FlowSourceCc = DataFlow::Global<ConfigSourceCc>;

module FlowSinkCc = DataFlow::Global<ConfigSinkCc>;

module FlowEqualCc = DataFlow::Global<ConfigEqualCc>;

module HasFlowTest implements TestSig {
  string getARelevantTag() { result = ["SrcCc", "SinkCc", "EqCc"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node src, DataFlow::Node sink |
      tag = "SrcCc" and
      FlowSourceCc::flow(src, sink)
      or
      tag = "SinkCc" and
      FlowSinkCc::flow(src, sink)
      or
      tag = "EqCc" and
      FlowEqualCc::flow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = src.asExpr().(MethodCall).getAnArgument().toString()
    )
  }
}

import MakeTest<HasFlowTest>
