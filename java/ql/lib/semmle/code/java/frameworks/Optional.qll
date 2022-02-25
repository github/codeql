/** Definitions related to `java.util.Optional`. */

import semmle.code.java.dataflow.ExternalFlow

private class OptionalModel extends SummaryModelCsv {
  override predicate row(string s) {
    s =
      [
        "java.util;Optional;false;filter;;;Argument[-1].Element;ReturnValue.Element;value",
        "java.util;Optional;false;filter;;;Argument[-1].Element;Argument[0].Parameter[0];value",
        "java.util;Optional;false;flatMap;;;Argument[-1].Element;Argument[0].Parameter[0];value",
        "java.util;Optional;false;flatMap;;;Argument[0].ReturnValue;ReturnValue;value",
        "java.util;Optional;false;get;;;Argument[-1].Element;ReturnValue;value",
        "java.util;Optional;false;ifPresent;;;Argument[-1].Element;Argument[0].Parameter[0];value",
        "java.util;Optional;false;ifPresentOrElse;;;Argument[-1].Element;Argument[0].Parameter[0];value",
        "java.util;Optional;false;map;;;Argument[-1].Element;Argument[0].Parameter[0];value",
        "java.util;Optional;false;map;;;Argument[0].ReturnValue;ReturnValue.Element;value",
        "java.util;Optional;false;of;;;Argument[0];ReturnValue.Element;value",
        "java.util;Optional;false;ofNullable;;;Argument[0];ReturnValue.Element;value",
        "java.util;Optional;false;or;;;Argument[-1].Element;ReturnValue.Element;value",
        "java.util;Optional;false;or;;;Argument[0].ReturnValue;ReturnValue;value",
        "java.util;Optional;false;orElse;;;Argument[-1].Element;ReturnValue;value",
        "java.util;Optional;false;orElse;;;Argument[0];ReturnValue;value",
        "java.util;Optional;false;orElseGet;;;Argument[-1].Element;ReturnValue;value",
        "java.util;Optional;false;orElseGet;;;Argument[0].ReturnValue;ReturnValue;value",
        "java.util;Optional;false;orElseThrow;;;Argument[-1].Element;ReturnValue;value",
        "java.util;Optional;false;stream;;;Argument[-1].Element;ReturnValue.Element;value"
      ]
  }
}
