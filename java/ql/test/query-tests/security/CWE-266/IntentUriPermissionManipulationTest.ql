import java
import TestUtilities.InlineFlowTest
import semmle.code.java.security.IntentUriPermissionManipulationQuery

class IntentUriPermissionManipulationTest extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) { none() }

  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) {
    IntentUriPermissionManipulationFlow::flow(src, sink)
  }
}
