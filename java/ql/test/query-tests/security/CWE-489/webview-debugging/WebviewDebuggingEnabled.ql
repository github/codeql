import java
import TestUtilities.InlineFlowTest
import semmle.code.java.security.WebviewDubuggingEnabledQuery

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() { none() }

  override DataFlow::Configuration getValueFlowConfig() {
    result = any(WebviewDebugEnabledConfig c)
  }
}
