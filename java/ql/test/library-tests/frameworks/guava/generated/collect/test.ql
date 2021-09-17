import java
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "generatedtest;Test;false;newWithElementDefault;(Object);;Argument[0];Element of ReturnValue;value",
        "generatedtest;Test;false;getElementDefault;(Object);;Element of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithMapKeyDefault;(Object);;Argument[0];MapKey of ReturnValue;value",
        "generatedtest;Test;false;getMapKeyDefault;(Object);;MapKey of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithMapValueDefault;(Object);;Argument[0];MapValue of ReturnValue;value",
        "generatedtest;Test;false;getMapValueDefault;(Object);;MapValue of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithTable_rowKeyDefault;(Object);;Argument[0];SyntheticField[com.google.common.collect.Table.rowKey] of ReturnValue;value",
        "generatedtest;Test;false;getTable_rowKeyDefault;(Object);;SyntheticField[com.google.common.collect.Table.rowKey] of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithTable_columnKeyDefault;(Object);;Argument[0];SyntheticField[com.google.common.collect.Table.columnKey] of ReturnValue;value",
        "generatedtest;Test;false;getTable_columnKeyDefault;(Object);;SyntheticField[com.google.common.collect.Table.columnKey] of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithMapDifference_leftDefault;(Object);;Argument[0];SyntheticField[com.google.common.collect.MapDifference.left] of ReturnValue;value",
        "generatedtest;Test;false;getMapDifference_leftDefault;(Object);;SyntheticField[com.google.common.collect.MapDifference.left] of Argument[0];ReturnValue;value",
        "generatedtest;Test;false;newWithMapDifference_rightDefault;(Object);;Argument[0];SyntheticField[com.google.common.collect.MapDifference.right] of ReturnValue;value",
        "generatedtest;Test;false;getMapDifference_rightDefault;(Object);;SyntheticField[com.google.common.collect.MapDifference.right] of Argument[0];ReturnValue;value"
      ]
  }
}
