/** Definitions of taint steps in String and String-related classes of the JDK */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class StringSummaryCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "java.lang;String;false;String;;;Argument[0];Argument[-1];taint"
      ]
  }
}
