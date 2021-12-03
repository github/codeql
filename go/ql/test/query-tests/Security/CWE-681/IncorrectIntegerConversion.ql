import go
import TestUtilities.InlineFlowTest
import semmle.go.security.IncorrectIntegerConversionLib

class IncorrectIntegerConversionTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() {
    result = any(ConversionWithoutBoundsCheckConfig config)
  }

  override DataFlow::Configuration getTaintFlowConfig() { none() }
}
