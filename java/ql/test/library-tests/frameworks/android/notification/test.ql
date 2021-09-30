import java
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "generatedtest;Test;false;getMapKeyDefault;(Bundle);;MapKey of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newActionBuilderWithExtras;(Bundle);;Argument[0];SyntheticField[android.app.Notification$Action$Builder.extras] of ReturnValue;value",
        "generatedtest;Test;false;newBuilderWithExtras;(Bundle);;Argument[0];SyntheticField[android.app.Notification$Builder.extras] of ReturnValue;value"
      ]
  }
}
