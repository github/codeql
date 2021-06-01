import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.InsecureBasicAuth
import TestUtilities.InlineExpectationsTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "test:cwe:insecure-basic-auth" }

  override predicate isSource(DataFlow::Node src) { src instanceof InsecureBasicAuthSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof InsecureBasicAuthSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(InsecureBasicAuthAdditionalTaintStep c).step(node1, node2)
  }
}

class HasInsecureBasicAuthTest extends InlineExpectationsTest {
  HasInsecureBasicAuthTest() { this = "HasInsecureBasicAuthTest" }

  override string getARelevantTag() { result = "hasInsecureBasicAuth" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasInsecureBasicAuth" and
    exists(DataFlow::Node src, DataFlow::Node sink, Conf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
