/** Definitions of flow steps through utility methods of `org.springframework.util.SpringUtils`. */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class SpringStringUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.springframework.util;StringUtils;false;addStringToArray;;;Argument[0..1];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;applyRelativePath;;;Argument[0..1];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;arrayToCommaDelimitedString;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;arrayToDelimitedString;;;Argument[0..1];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;capitalize;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;cleanPath;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;collectionToCommaDelimitedString;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;collectionToDelimitedString;;;Argument[0..1];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;collectionToDelimitedString;(java.util.Collection,java.lang.String,java.lang.String,java.lang.String);;Argument[2..3];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;commaDelimitedListToSet;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;commaDelimitedListToStringArray;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;concatenateStringArrays;;;Argument[0..1];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;delete;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;deleteAny;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;delimitedListToStringArray;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;getFilename;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;getFilenameExtension;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;mergeStringArrays;;;Argument[0..1];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;quote;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;quoteIfString;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;removeDuplicateStrings;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;replace;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;replace;;;Argument[2];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;sortStringArray;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;split;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;splitArrayElementsIntoProperties;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;stripFilenameExtension;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;tokenizeToStringArray;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;toStringArray;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;trimAllWhitespace;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;trimArrayElements;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;trimLeadingCharacter;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;trimLeadingWhitespace;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;trimTrailingCharacter;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;trimTrailingWhitespace;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;trimWhitespace;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;uncapitalize;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;unqualify;;;Argument[0];ReturnValue;taint",
        "org.springframework.util;StringUtils;false;uriDecode;;;Argument[0];ReturnValue;taint"
      ]
  }
}
