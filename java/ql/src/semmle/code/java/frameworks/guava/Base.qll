/** Definitions of flow steps through utility methods of `com.google.common.base`. */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class GuavaBaseCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        "com.google.common.base;Strings;false;emptyToNull;(String);;Argument[0];ReturnValue;value",
        "com.google.common.base;Strings;false;nullToEmpty;(String);;Argument[0];ReturnValue;value",
        "com.google.common.base;Strings;false;padStart;(String,int,char);;Argument[0];ReturnValue;taint",
        "com.google.common.base;Strings;false;padEnd;(String,int,char);;Argument[0];ReturnValue;taint",
        "com.google.common.base;Strings;false;repeat;(String,int);;Argument[0];ReturnValue;taint",
        "com.google.common.base;Strings;false;lenientFormat;(String,Object[]);;Argument;ReturnValue;taint",
        "com.google.common.base;Joiner;false;on;(String);;Argument[0];ReturnValue;taint",
        "com.google.common.base;Joiner;false;skipNulls;();;Argument[-1];ReturnValue;taint",
        "com.google.common.base;Joiner;false;useForNull;(String);;Argument[-1];ReturnValue;taint",
        "com.google.common.base;Joiner;false;useForNull;(String);;Argument[0];ReturnValue;taint",
        "com.google.common.base;Joiner;false;withKeyValueSeparator;(String);;Argument[0];ReturnValue;taint",
        "com.google.common.base;Joiner;false;withKeyValueSeparator;(String);;Argument[-1];ReturnValue;taint",
        "com.google.common.base;Joiner;false;withKeyValueSeparator;(char);;Argument[-1];ReturnValue;taint",
        // Note: The signatures of some of the appendTo methods involve collection flow
        "com.google.common.base;Joiner;false;appendTo;;;Argument;Argument[0];taint",
        "com.google.common.base;Joiner;false;appendTo;;;Argument[0];ReturnValue;value",
        "com.google.common.base;Joiner;false;join;;;Argument;ReturnValue;taint",
        "com.google.common.base;Joiner$MapJoiner;false;useForNull;(String);;Argument[0];ReturnValue;taint",
        "com.google.common.base;Joiner$MapJoiner;false;useForNull;(String);;Argument[-1];ReturnValue;taint",
        "com.google.common.base;Joiner$MapJoiner;false;appendTo;;;Argument;Argument[0];taint",
        "com.google.common.base;Joiner$MapJoiner;false;appendTo;;;Argument[0];ReturnValue;value",
        "com.google.common.base;Joiner$MapJoiner;false;join;;;Argument;ReturnValue;taint",
        "com.google.common.base;Splitter;false;split;(CharSequence);;Argument[0];ReturnValue;taint",
        "com.google.common.base;Splitter;false;splitToList;(CharSequence);;Argument[0];ReturnValue;taint",
        "com.google.common.base;Splitter;false;splitToStream;(CharSequence);;Argument[0];ReturnValue;taint",
        "com.google.common.base;Splitter$MapSplitter;false;split;(CharSequence);;Argument[0];ReturnValue;taint",
        "com.google.common.base;Preconditions;false;checkNotNull;;;Argument[0];ReturnValue;value"
      ]
  }
}
