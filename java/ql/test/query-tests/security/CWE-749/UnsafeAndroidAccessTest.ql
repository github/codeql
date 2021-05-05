import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.UnsafeAndroidAccess

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:cwe:jexl-injection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof FetchUntrustedResourceSink }
}

class UnsafeAndroidAccessTest extends InlineExpectationsTest {
  UnsafeAndroidAccessTest() { this = "HasUnsafeAndroidAccess" }

  override string getARelevantTag() { result = "hasUnsafeAndroidAccess" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasUnsafeAndroidAccess" and
    exists(DataFlow::Node src, DataFlow::Node sink, Conf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
