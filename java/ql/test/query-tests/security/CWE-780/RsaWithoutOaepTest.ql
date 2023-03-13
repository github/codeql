import java
import TestUtilities.InlineExpectationsTest
import TestUtilities.InlineFlowTest
import semmle.code.java.security.RsaWithoutOaepQuery

class EnableLegacy extends EnableLegacyConfiguration {
  EnableLegacy() { exists(this) }
}

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() { result instanceof RsaWithoutOaepConfig }

  override DataFlow::Configuration getValueFlowConfig() { none() }
}
