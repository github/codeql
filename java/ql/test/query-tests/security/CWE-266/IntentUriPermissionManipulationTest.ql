import java
import TestUtilities.InlineFlowTest
import semmle.code.java.security.IntentUriPermissionManipulationQuery

class IntentUriPermissionManipulationTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }

  override TaintTracking::Configuration getTaintFlowConfig() {
    result instanceof IntentUriPermissionManipulationConf
  }
}
