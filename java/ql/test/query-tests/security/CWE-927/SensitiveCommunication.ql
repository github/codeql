import java
import semmle.code.java.security.AndroidSensitiveCommunicationQuery
import TestUtilities.InlineExpectationsTest
import TestUtilities.InlineFlowTest

class EnableLegacy extends EnableLegacyConfiguration {
  EnableLegacy() { exists(this) }
}

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() {
    result = any(SensitiveCommunicationConfig c)
  }

  override DataFlow::Configuration getValueFlowConfig() { none() }
}
