/** Definitions of data flow steps for determining flow of regular expressions. */

import java
import semmle.code.java.dataflow.ExternalFlow

private class RegexSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"namespace;type;subtypes;name;signature;ext;input;kind"
        "java.util.regex;Pattern;false;compile;(String);;Argument[0];regex-compile",
        "java.util.regex;Pattern;false;compile;(String,int);;Argument[0];regex-compile",
        "java.util.regex;Pattern;false;matches;(String,CharSequence);;Argument[0];regex-compile",
        "java.util;String;false;matches;(String);;Argument[0];regex-compile",
        "java.util;String;false;split;(String);;Argument[0];regex-compile",
        "java.util;String;false;split;(String,int);;Argument[0];regex-compile",
        "java.util;String;false;replaceAll;(String,String);;Argument[0];regex-compile",
        "java.util;String;false;replaceFirst;(String,String);;Argument[0];regex-compile",
        "com.google.common.base;Splitter;false;onPattern;(String);;Argument[0];regex-compile"
      ]
  }
}
