import java
import semmle.code.java.security.InsecureTrustManagerQuery
import TestUtilities.InlineFlowTest

class EnableLegacy extends EnableLegacyConfiguration {
  EnableLegacy() { exists(this) }
}

class InsecureTrustManagerTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() {
    result = any(InsecureTrustManagerConfiguration c)
  }
}
