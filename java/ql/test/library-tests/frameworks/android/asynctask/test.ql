import java
import TestUtilities.InlineFlowTest

class AsyncTaskTest extends InlineFlowTest {
  override TaintTracking::Configuration getTaintFlowConfig() { none() }
}
