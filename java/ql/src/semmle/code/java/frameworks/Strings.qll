/** Definitions of taint steps in String and String-related classes of the JDK */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class StringSummaryCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "java.lang;String;false;concat;(String);;Argument[0];ReturnValue;taint",
        "java.lang;String;false;copyValueOf;;;Argument[0];ReturnValue;taint",
        "java.lang;String;false;endsWith;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;format;(Locale,String,Object[]);;Argument[1];ReturnValue;taint",
        "java.lang;String;false;format;(Locale,String,Object[]);;ArrayElement of Argument[2];ReturnValue;taint",
        "java.lang;String;false;format;(String,Object[]);;Argument[0];ReturnValue;taint",
        "java.lang;String;false;format;(String,Object[]);;ArrayElement of Argument[1];ReturnValue;taint",
        "java.lang;String;false;formatted;(Object[]);;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;formatted;(Object[]);;ArrayElement of Argument[0];ReturnValue;taint",
        "java.lang;String;false;getBytes;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;indent;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;intern;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;join;;;Argument[0..1];ReturnValue;taint",
        "java.lang;String;false;repeat;(int);;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;split;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;String;;;Argument[0];Argument[-1];value",
        "java.lang;String;false;strip;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;stripIndent;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;stripLeading;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;stripTrailing;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;substring;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;toCharArray;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;toLowerCase;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;toString;;;Argument[-1];ReturnValue;value",
        "java.lang;String;false;toUpperCase;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;trim;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;valueOf;(char);;Argument[0];ReturnValue;taint",
        "java.lang;String;false;valueOf;(char[],int,int);;Argument[0];ReturnValue;taint",
        "java.lang;String;false;valueOf;(char[]);;Argument[0];ReturnValue;taint"
      ]
  }
}
