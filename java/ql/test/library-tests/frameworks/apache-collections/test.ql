import java
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "generatedtest;Test;false;newWithElement;;;Argument[0];Element of ReturnValue;value",
        "generatedtest;Test;false;getElement;;;Element of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithArrayElement;;;Argument[0];ArrayElement of ReturnValue;value",
        "generatedtest;Test;false;getArrayElement;;;ArrayElement of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithMapValue;;;Argument[0];MapValue of ReturnValue;value",
        "generatedtest;Test;false;getMapValue;;;MapValue of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithMapKey;;;Argument[0];MapKey of ReturnValue;value",
        "generatedtest;Test;false;getMapKey;;;MapKey of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newRBWithMapValue;;;Argument[0];MapValue of ReturnValue;value",
        "generatedtest;Test;false;newRBWithMapKey;;;Argument[0];MapKey of ReturnValue;value"
      ]
  }
}
