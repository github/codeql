import java
import TestUtilities.InlineFlowTest
import semmle.code.java.security.SensitiveLoggingQuery

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() {
    result instanceof SensitiveLoggerConfiguration
  }

  override DataFlow::Configuration getValueFlowConfig() { none() }
}
