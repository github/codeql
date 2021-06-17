import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.RequestForgeryConfig
import semmle.code.java.security.UnsafeAndroidAccess
import TestUtilities.InlineExpectationsTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:cwe:unsafe-android-access" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UrlResourceSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof RequestForgerySanitizer
  }
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
