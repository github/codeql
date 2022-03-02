import java
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row = "generatedtest;Test;false;getStreamElement;;;Argument[0].Element;ReturnValue;value"
  }
}
