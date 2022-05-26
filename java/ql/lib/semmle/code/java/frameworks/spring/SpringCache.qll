/**
 * Provides models for the `org.springframework.cache` package.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class FlowSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.springframework.cache;Cache$ValueRetrievalException;false;ValueRetrievalException;;;Argument[0];Argument[-1].MapKey;value",
        "org.springframework.cache;Cache$ValueRetrievalException;false;getKey;;;Argument[-1].MapKey;ReturnValue;value",
        "org.springframework.cache;Cache$ValueWrapper;true;get;;;Argument[-1].MapValue;ReturnValue;value",
        "org.springframework.cache;Cache;true;get;(Object);;Argument[-1].MapValue;ReturnValue.MapValue;value",
        "org.springframework.cache;Cache;true;get;(Object,Callable);;Argument[-1].MapValue;ReturnValue;value",
        "org.springframework.cache;Cache;true;get;(Object,Class);;Argument[-1].MapValue;ReturnValue;value",
        "org.springframework.cache;Cache;true;getNativeCache;;;Argument[-1].MapKey;ReturnValue.MapKey;value",
        "org.springframework.cache;Cache;true;getNativeCache;;;Argument[-1].MapValue;ReturnValue.MapValue;value",
        "org.springframework.cache;Cache;true;put;;;Argument[0];Argument[-1].MapKey;value",
        "org.springframework.cache;Cache;true;put;;;Argument[1];Argument[-1].MapValue;value",
        "org.springframework.cache;Cache;true;putIfAbsent;;;Argument[0];Argument[-1].MapKey;value",
        "org.springframework.cache;Cache;true;putIfAbsent;;;Argument[1];Argument[-1].MapValue;value",
        "org.springframework.cache;Cache;true;putIfAbsent;;;Argument[-1].MapValue;ReturnValue.MapValue;value"
      ]
  }
}
