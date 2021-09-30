import java
import semmle.code.java.security.ImplicitPendingIntentsQuery
import TestUtilities.InlineFlowTest

class ImplicitPendingIntentsTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }

  override DataFlow::Configuration getTaintFlowConfig() {
    result instanceof ImplicitPendingIntentStartConf
  }
}
