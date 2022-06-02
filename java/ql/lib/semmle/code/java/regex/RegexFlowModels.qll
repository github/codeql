/** Definitions of data flow steps for determining flow of regular expressions. */

import java
import semmle.code.java.dataflow.ExternalFlow

private class RegexSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"namespace;type;subtypes;name;signature;ext;input;kind"
        "java.util.regex;Matcher;false;matches;();;Argument[-1];regex-use[f]",
        "java.util.regex;Pattern;false;asMatchPredicate;();;Argument[-1];regex-use[f]",
        "java.util.regex;Pattern;false;compile;(String);;Argument[0];regex-use[]",
        "java.util.regex;Pattern;false;compile;(String,int);;Argument[0];regex-use[]",
        "java.util.regex;Pattern;false;matcher;(CharSequence);;Argument[-1];regex-use[0]",
        "java.util.regex;Pattern;false;matches;(String,CharSequence);;Argument[0];regex-use[f1]",
        "java.util.regex;Pattern;false;split;(CharSequence);;Argument[-1];regex-use[0]",
        "java.util.regex;Pattern;false;split;(CharSequence,int);;Argument[-1];regex-use[0]",
        "java.util.regex;Pattern;false;splitAsStream;(CharSequence);;Argument[-1];regex-use[0]",
        "java.util.function;Predicate;false;test;(Object);;Argument[-1];regex-use[0]",
        "java.lang;String;false;matches;(String);;Argument[0];regex-use[f-1]",
        "java.lang;String;false;split;(String);;Argument[0];regex-use[-1]",
        "java.lang;String;false;split;(String,int);;Argument[0];regex-use[-1]",
        "java.lang;String;false;replaceAll;(String,String);;Argument[0];regex-use[-1]",
        "java.lang;String;false;replaceFirst;(String,String);;Argument[0];regex-use[-1]",
        "com.google.common.base;Splitter;false;onPattern;(String);;Argument[0];regex-use[]",
        "com.google.common.base;Splitter;false;split;(CharSequence);;Argument[-1];regex-use[0]",
        "com.google.common.base;Splitter;false;splitToList;(CharSequence);;Argument[-1];regex-use[0]",
        "com.google.common.base;Splitter$MapSplitter;false;split;(CharSequence);;Argument[-1];regex-use[0]",
      ]
  }
}
