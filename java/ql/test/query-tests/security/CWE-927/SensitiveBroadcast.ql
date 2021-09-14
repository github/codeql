import java
import semmle.code.java.security.AndroidSensitiveBroadcastQuery
import TestUtilities.InlineExpectationsTest
import TestUtilities.InlineFlowTest

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() { result = any(SensitiveBroadcastConfig c) }

  override DataFlow::Configuration getValueFlowConfig() { none() }
}
