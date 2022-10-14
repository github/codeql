import java
import TestUtilities.InlineFlowTest
import CsvValidation

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "my.qltest.synth;A;false;storeInArray;(String);;Argument[0];SyntheticGlobal[db1].ArrayElement;value;manual",
        "my.qltest.synth;A;false;storeTaintInArray;(String);;Argument[0];SyntheticGlobal[db1].ArrayElement;taint;manual",
        "my.qltest.synth;A;false;storeValue;(String);;Argument[0];SyntheticGlobal[db1];value;manual",
        "my.qltest.synth;A;false;readValue;();;SyntheticGlobal[db1];ReturnValue;value;manual",
        "my.qltest.synth;A;false;readArray;();;SyntheticGlobal[db1].ArrayElement;ReturnValue;value;manual",
      ]
  }
}
