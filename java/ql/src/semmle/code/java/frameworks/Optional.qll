/** Definitions related to `java.util.Optional`. */

import semmle.code.java.dataflow.ExternalFlow

private class OptionalModel extends SummaryModelCsv {
  override predicate row(string s) {
    s =
      [
        "java.util;Optional;false;filter;;;Element of Argument[-1];Element of ReturnValue;value",
        "java.util;Optional;false;get;;;Element of Argument[-1];ReturnValue;value",
        "java.util;Optional;false;of;;;Argument[0];Element of ReturnValue;value",
        "java.util;Optional;false;ofNullable;;;Argument[0];Element of ReturnValue;value",
        "java.util;Optional;false;or;;;Element of Argument[-1];Element of ReturnValue;value",
        "java.util;Optional;false;orElse;;;Element of Argument[-1];ReturnValue;value",
        "java.util;Optional;false;orElse;;;Argument[0];ReturnValue;value",
        "java.util;Optional;false;orElseGet;;;Element of Argument[-1];ReturnValue;value",
        "java.util;Optional;false;orElseThrow;;;Element of Argument[-1];ReturnValue;value",
        "java.util;Optional;false;stream;;;Element of Argument[-1];Element of ReturnValue;value"
      ]
  }
}
