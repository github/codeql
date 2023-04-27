import java
import TestUtilities.InlineFlowTest
import semmle.code.java.security.WebviewDebuggingEnabledQuery

class HasFlowTest extends InlineFlowTest {
  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) { none() }

  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) {
    WebviewDebugEnabledFlow::flow(src, sink)
  }
}
