import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XSS
import semmle.code.java.security.UrlRedirect
import TestUtilities.InlineExpectationsTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:frameworks:apache-http" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("taint")
    or
    n instanceof RemoteFlowSource
  }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
    or
    n instanceof XssSink
    or
    n instanceof UrlRedirectSink
  }
}

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "hasTaintFlow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink, Conf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
