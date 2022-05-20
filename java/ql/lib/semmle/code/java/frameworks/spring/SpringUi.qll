/**
 * Provides models for the `org.springframework.ui` package.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class FlowSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.springframework.ui;Model;true;addAllAttributes;;;Argument[-1];ReturnValue;value",
        "org.springframework.ui;Model;true;addAllAttributes;(Collection);;Argument[0].Element;Argument[-1].MapValue;value",
        "org.springframework.ui;Model;true;addAllAttributes;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
        "org.springframework.ui;Model;true;addAllAttributes;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
        "org.springframework.ui;Model;true;addAttribute;;;Argument[-1];ReturnValue;value",
        "org.springframework.ui;Model;true;addAttribute;(Object);;Argument[0];Argument[-1].MapValue;value",
        "org.springframework.ui;Model;true;addAttribute;(String,Object);;Argument[0];Argument[-1].MapKey;value",
        "org.springframework.ui;Model;true;addAttribute;(String,Object);;Argument[1];Argument[-1].MapValue;value",
        "org.springframework.ui;Model;true;asMap;;;Argument[-1].MapKey;ReturnValue.MapKey;value",
        "org.springframework.ui;Model;true;asMap;;;Argument[-1].MapValue;ReturnValue.MapValue;value",
        "org.springframework.ui;Model;true;getAttribute;;;Argument[-1].MapValue;ReturnValue;value",
        "org.springframework.ui;Model;true;mergeAttributes;;;Argument[-1];ReturnValue;value",
        "org.springframework.ui;Model;true;mergeAttributes;;;Argument[0].MapKey;Argument[-1].MapKey;value",
        "org.springframework.ui;Model;true;mergeAttributes;;;Argument[0].MapValue;Argument[-1].MapValue;value",
        "org.springframework.ui;ModelMap;false;ModelMap;(Object);;Argument[0];Argument[-1].MapValue;value",
        "org.springframework.ui;ModelMap;false;ModelMap;(String,Object);;Argument[0];Argument[-1].MapKey;value",
        "org.springframework.ui;ModelMap;false;ModelMap;(String,Object);;Argument[1];Argument[-1].MapValue;value",
        "org.springframework.ui;ModelMap;false;addAllAttributes;;;Argument[-1];ReturnValue;value",
        "org.springframework.ui;ModelMap;false;addAllAttributes;(Collection);;Argument[0].Element;Argument[-1].MapValue;value",
        "org.springframework.ui;ModelMap;false;addAllAttributes;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
        "org.springframework.ui;ModelMap;false;addAllAttributes;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
        "org.springframework.ui;ModelMap;false;addAttribute;;;Argument[-1];ReturnValue;value",
        "org.springframework.ui;ModelMap;false;addAttribute;(Object);;Argument[0];Argument[-1].MapValue;value",
        "org.springframework.ui;ModelMap;false;addAttribute;(String,Object);;Argument[0];Argument[-1].MapKey;value",
        "org.springframework.ui;ModelMap;false;addAttribute;(String,Object);;Argument[1];Argument[-1].MapValue;value",
        "org.springframework.ui;ModelMap;false;getAttribute;;;Argument[-1].MapValue;ReturnValue;value",
        "org.springframework.ui;ModelMap;false;mergeAttributes;;;Argument[-1];ReturnValue;value",
        "org.springframework.ui;ModelMap;false;mergeAttributes;;;Argument[0].MapKey;Argument[-1].MapKey;value",
        "org.springframework.ui;ModelMap;false;mergeAttributes;;;Argument[0].MapValue;Argument[-1].MapValue;value",
        "org.springframework.ui;ConcurrentModel;false;ConcurrentModel;(Object);;Argument[0];Argument[-1].MapValue;value",
        "org.springframework.ui;ConcurrentModel;false;ConcurrentModel;(String,Object);;Argument[0];Argument[-1].MapKey;value",
        "org.springframework.ui;ConcurrentModel;false;ConcurrentModel;(String,Object);;Argument[1];Argument[-1].MapValue;value"
      ]
  }
}
