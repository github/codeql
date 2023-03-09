import java
import TestUtilities.InlineFlowTest
import semmle.code.java.security.UnsafeContentUriResolutionQuery

class EnableLegacy extends EnableLegacyConfiguration {
  EnableLegacy() { exists(this) }
}

class Test extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }

  override TaintTracking::Configuration getTaintFlowConfig() {
    result instanceof UnsafeContentResolutionConf
  }
}
