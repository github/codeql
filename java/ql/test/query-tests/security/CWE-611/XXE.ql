import java
import TestUtilities.InlineFlowTest
import semmle.code.java.security.XxeRemoteQuery

class HasFlowTest extends InlineFlowTest {
  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) {
    XxeFlow::flow(src, sink)
  }

  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) { none() }
}
