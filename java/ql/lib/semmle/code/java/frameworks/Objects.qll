/** Definitions of taint steps in Objects class of the JDK */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class ObjectsSummaryCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "java.util;Objects;false;requireNonNull;;;Argument[0];ReturnValue;value",
        "java.util;Objects;false;requireNonNullElse;;;Argument[0];ReturnValue;value",
        "java.util;Objects;false;requireNonNullElse;;;Argument[1];ReturnValue;value",
        "java.util;Objects;false;requireNonNullElseGet;;;Argument[0];ReturnValue;value",
        "java.util;Objects;false;toString;;;Argument[1];ReturnValue;value"
      ]
  }
}
