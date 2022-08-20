import java
import semmle.code.java.security.InsecureTrustManagerQuery
import TestUtilities.InlineFlowTest

class InsecureTrustManagerTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() {
    result = any(InsecureTrustManagerConfiguration c)
  }
}
