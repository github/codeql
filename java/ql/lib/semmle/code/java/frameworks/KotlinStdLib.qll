/** Definitions of taint steps in the KotlinStdLib framework */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class KotlinStdLibSummaryCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "kotlin.jvm.internal;ArrayIteratorKt;false;iterator;(Object[]);;Argument[0].ArrayElement;ReturnValue.Element;value;manual"
  }
}
