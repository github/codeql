import java
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row = "generatedtest;Test;false;getStreamElement;;;Element of Argument[0];ReturnValue;value"
  }
}
