import java
import TestUtilities.InlineFlowTest
import semmle.code.java.security.SensitiveLoggingQuery

class EnableLegacy extends EnableLegacyConfiguration {
  EnableLegacy() { exists(this) }
}

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() {
    result instanceof SensitiveLoggerConfiguration
  }

  override DataFlow::Configuration getValueFlowConfig() { none() }
}
