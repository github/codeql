import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineExpectationsTest

class LocalSource extends DataFlow::Node instanceof UserInput {
  LocalSource() { not this instanceof RemoteFlowSource }
}

predicate isTestSink(DataFlow::Node n) {
  exists(MethodCall ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
}

module LocalValueConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n instanceof LocalSource }

  predicate isSink(DataFlow::Node n) { isTestSink(n) }
}

module LocalValueFlow = DataFlow::Global<LocalValueConfig>;

module LocalTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n instanceof LocalSource }

  predicate isSink(DataFlow::Node n) { isTestSink(n) }
}

module LocalTaintFlow = TaintTracking::Global<LocalTaintConfig>;

module LocalFlowTest implements TestSig {
  string getARelevantTag() { result = ["hasLocalValueFlow", "hasLocalTaintFlow"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasLocalValueFlow" and
    exists(DataFlow::Node sink | LocalValueFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
    or
    tag = "hasLocalTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink |
      LocalTaintFlow::flow(src, sink) and not LocalValueFlow::flow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<LocalFlowTest>
