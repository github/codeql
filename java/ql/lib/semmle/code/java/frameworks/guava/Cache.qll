/** Flow steps through methods of `com.google.common.cache` */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class GuavaBaseCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "com.google.common.cache;Cache;true;asMap;();;Argument[-1].MapKey;ReturnValue.MapKey;value",
        "com.google.common.cache;Cache;true;asMap;();;Argument[-1].MapValue;ReturnValue.MapValue;value",
        // lambda flow from Argument[1] not implemented
        "com.google.common.cache;Cache;true;get;(Object,Callable);;Argument[-1].MapValue;ReturnValue;value",
        "com.google.common.cache;Cache;true;getIfPresent;(Object);;Argument[-1].MapValue;ReturnValue;value",
        // the true flow to MapKey of ReturnValue for getAllPresent is the intersection of the these inputs, but intersections cannot be modelled fully accurately.
        "com.google.common.cache;Cache;true;getAllPresent;(Iterable);;Argument[-1].MapKey;ReturnValue.MapKey;value",
        "com.google.common.cache;Cache;true;getAllPresent;(Iterable);;Argument[0].Element;ReturnValue.MapKey;value",
        "com.google.common.cache;Cache;true;getAllPresent;(Iterable);;Argument[-1].MapValue;ReturnValue.MapValue;value",
        "com.google.common.cache;Cache;true;put;(Object,Object);;Argument[0];Argument[-1].MapKey;value",
        "com.google.common.cache;Cache;true;put;(Object,Object);;Argument[1];Argument[-1].MapValue;value",
        "com.google.common.cache;Cache;true;putAll;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
        "com.google.common.cache;Cache;true;putAll;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
        "com.google.common.cache;LoadingCache;true;get;(Object);;Argument[-1].MapValue;ReturnValue;value",
        "com.google.common.cache;LoadingCache;true;getUnchecked;(Object);;Argument[-1].MapValue;ReturnValue;value",
        "com.google.common.cache;LoadingCache;true;apply;(Object);;Argument[-1].MapValue;ReturnValue;value",
        "com.google.common.cache;LoadingCache;true;getAll;(Iterable);;Argument[0].Element;ReturnValue.MapKey;value",
        "com.google.common.cache;LoadingCache;true;getAll;(Iterable);;Argument[0].Element;Argument[-1].MapKey;value",
        "com.google.common.cache;LoadingCache;true;getAll;(Iterable);;Argument[-1].MapValue;ReturnValue.MapValue;value"
      ]
  }
}
