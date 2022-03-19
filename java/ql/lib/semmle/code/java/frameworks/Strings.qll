/** Definitions of taint steps in String and String-related classes of the JDK */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class StringSummaryCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "java.lang;String;false;concat;(String);;Argument[0];ReturnValue;taint",
        "java.lang;String;false;concat;(String);;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;copyValueOf;;;Argument[0];ReturnValue;taint",
        "java.lang;String;false;endsWith;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;format;(Locale,String,Object[]);;Argument[1];ReturnValue;taint",
        "java.lang;String;false;format;(Locale,String,Object[]);;Argument[2].ArrayElement;ReturnValue;taint",
        "java.lang;String;false;format;(String,Object[]);;Argument[0];ReturnValue;taint",
        "java.lang;String;false;format;(String,Object[]);;Argument[1].ArrayElement;ReturnValue;taint",
        "java.lang;String;false;formatted;(Object[]);;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;formatted;(Object[]);;Argument[0].ArrayElement;ReturnValue;taint",
        "java.lang;String;false;getChars;;;Argument[-1];Argument[2];taint",
        "java.lang;String;false;getBytes;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;indent;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;intern;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;join;;;Argument[0..1];ReturnValue;taint",
        "java.lang;String;false;repeat;(int);;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;split;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;String;;;Argument[0];Argument[-1];taint",
        "java.lang;String;false;strip;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;stripIndent;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;stripLeading;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;stripTrailing;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;substring;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;toCharArray;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;toLowerCase;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;toString;;;Argument[-1];ReturnValue;value",
        "java.lang;String;false;toUpperCase;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;translateEscapes;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;trim;;;Argument[-1];ReturnValue;taint",
        "java.lang;String;false;valueOf;(char);;Argument[0];ReturnValue;taint",
        "java.lang;String;false;valueOf;(char[],int,int);;Argument[0];ReturnValue;taint",
        "java.lang;String;false;valueOf;(char[]);;Argument[0];ReturnValue;taint",
        "java.lang;AbstractStringBuilder;true;AbstractStringBuilder;(String);;Argument[0];Argument[-1];taint",
        "java.lang;AbstractStringBuilder;true;append;;;Argument[0];Argument[-1];taint",
        "java.lang;AbstractStringBuilder;true;append;;;Argument[-1];ReturnValue;value",
        "java.lang;AbstractStringBuilder;true;getChars;;;Argument[-1];Argument[2];taint",
        "java.lang;AbstractStringBuilder;true;insert;;;Argument[1];Argument[-1];taint",
        "java.lang;AbstractStringBuilder;true;insert;;;Argument[-1];ReturnValue;value",
        "java.lang;AbstractStringBuilder;true;replace;;;Argument[-1];ReturnValue;value",
        "java.lang;AbstractStringBuilder;true;replace;;;Argument[2];Argument[-1];taint",
        "java.lang;AbstractStringBuilder;true;reverse;;;Argument[-1];ReturnValue;value",
        "java.lang;AbstractStringBuilder;true;subSequence;;;Argument[-1];ReturnValue;taint",
        "java.lang;AbstractStringBuilder;true;substring;;;Argument[-1];ReturnValue;taint",
        "java.lang;AbstractStringBuilder;true;toString;;;Argument[-1];ReturnValue;taint",
        "java.lang;StringBuffer;true;StringBuffer;(CharSequence);;Argument[0];Argument[-1];taint",
        "java.lang;StringBuffer;true;StringBuffer;(String);;Argument[0];Argument[-1];taint",
        "java.lang;StringBuilder;true;StringBuilder;;;Argument[0];Argument[-1];taint",
        "java.lang;CharSequence;true;subSequence;;;Argument[-1];ReturnValue;taint",
        "java.lang;CharSequence;true;toString;;;Argument[-1];ReturnValue;taint"
      ]
  }
}
