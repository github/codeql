/** Definitions of taint steps in Objects class of the JDK */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class ObjectsSummaryCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "java.lang;Appendable;false;append;;;Argument[0];Argument[-1];value",
        "java.lang;Appendable;false;append;;;Argument[-1];ReturnValue;value",
        "java.io;Writer;false;write;;;Argument[0];Argument[-1];value"
      ]
  }
}
