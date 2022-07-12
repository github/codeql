/** Definitions of data flow steps for determining flow of regular expressions. */

import java
import semmle.code.java.dataflow.ExternalFlow

private class RegexSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"namespace;type;subtypes;name;signature;ext;input;kind"
        "java.util.regex;Matcher;false;matches;();;Argument[-1];regex-use[f];manual",
        "java.util.regex;Pattern;false;asMatchPredicate;();;Argument[-1];regex-use[f];manual",
        "java.util.regex;Pattern;false;compile;(String);;Argument[0];regex-use[];manual",
        "java.util.regex;Pattern;false;compile;(String,int);;Argument[0];regex-use[];manual",
        "java.util.regex;Pattern;false;matcher;(CharSequence);;Argument[-1];regex-use[0];manual",
        "java.util.regex;Pattern;false;matches;(String,CharSequence);;Argument[0];regex-use[f1];manual",
        "java.util.regex;Pattern;false;split;(CharSequence);;Argument[-1];regex-use[0];manual",
        "java.util.regex;Pattern;false;split;(CharSequence,int);;Argument[-1];regex-use[0];manual",
        "java.util.regex;Pattern;false;splitAsStream;(CharSequence);;Argument[-1];regex-use[0];manual",
        "java.util.function;Predicate;false;test;(Object);;Argument[-1];regex-use[0];manual",
        "java.lang;String;false;matches;(String);;Argument[0];regex-use[f-1];manual",
        "java.lang;String;false;split;(String);;Argument[0];regex-use[-1];manual",
        "java.lang;String;false;split;(String,int);;Argument[0];regex-use[-1];manual",
        "java.lang;String;false;replaceAll;(String,String);;Argument[0];regex-use[-1];manual",
        "java.lang;String;false;replaceFirst;(String,String);;Argument[0];regex-use[-1];manual",
        "com.google.common.base;Splitter;false;onPattern;(String);;Argument[0];regex-use[];manual",
        "com.google.common.base;Splitter;false;split;(CharSequence);;Argument[-1];regex-use[0];manual",
        "com.google.common.base;Splitter;false;splitToList;(CharSequence);;Argument[-1];regex-use[0];manual",
        "com.google.common.base;Splitter$MapSplitter;false;split;(CharSequence);;Argument[-1];regex-use[0];manual",
      ]
  }
}
