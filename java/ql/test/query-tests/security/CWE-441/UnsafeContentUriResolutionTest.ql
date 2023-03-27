import java
import TestUtilities.InlineFlowTest
import semmle.code.java.security.UnsafeContentUriResolutionQuery

class Test extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) { none() }

  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) {
    UnsafeContentResolutionFlow::flow(src, sink)
  }
}
