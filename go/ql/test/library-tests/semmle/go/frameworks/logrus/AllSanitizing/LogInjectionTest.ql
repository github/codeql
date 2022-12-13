import go
import TestUtilities.InlineFlowTest
import semmle.go.security.LogInjection

class LogInjectionTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() {
    result = any(LogInjection::Configuration config)
  }

  override DataFlow::Configuration getValueFlowConfig() { none() }
}
