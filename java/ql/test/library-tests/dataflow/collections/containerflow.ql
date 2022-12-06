import java
import semmle.code.java.dataflow.DataFlow
import TestUtilities.InlineFlowTest

class HasFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getTaintFlowConfig() { none() }
}
