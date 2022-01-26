/** Definitions related to `java.util.regex`. */

import semmle.code.java.dataflow.ExternalFlow

private class RegexModel extends SummaryModelCsv {
  override predicate row(string s) {
    s =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "java.util.regex;Matcher;false;group;;;Argument[-1];ReturnValue;taint",
        "java.util.regex;Matcher;false;replaceAll;;;Argument[-1];ReturnValue;taint",
        "java.util.regex;Matcher;false;replaceAll;;;Argument[0];ReturnValue;taint",
        "java.util.regex;Matcher;false;replaceFirst;;;Argument[-1];ReturnValue;taint",
        "java.util.regex;Matcher;false;replaceFirst;;;Argument[0];ReturnValue;taint",
        "java.util.regex;Pattern;false;matcher;;;Argument[0];ReturnValue;taint",
        "java.util.regex;Pattern;false;quote;;;Argument[0];ReturnValue;taint",
        "java.util.regex;Pattern;false;split;;;Argument[0];ReturnValue;taint",
      ]
  }
}
