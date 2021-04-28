import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XPath
import TestUtilities.InlineExpectationsTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "test:xml:xpathinjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XPathInjectionSink }
}

class HasXPathInjectionTest extends InlineExpectationsTest {
  HasXPathInjectionTest() { this = "HasXPathInjectionTest" }

  override string getARelevantTag() { result = "hasXPathInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasXPathInjection" and
    exists(DataFlow::Node src, DataFlow::Node sink, Conf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
