/** Flow steps through methods of `com.google.common.cache` */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class GuavaBaseCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "com.google.common.cache;Cache;true;asMap;();;MapKey of Argument[-1];MapKey of ReturnValue;value",
        "com.google.common.cache;Cache;true;asMap;();;MapValue of Argument[-1];MapValue of ReturnValue;value",
        // lambda flow from Argument[1] not implemented
        "com.google.common.cache;Cache;true;get;(Object,Callable);;MapValue of Argument[-1];ReturnValue;value",
        "com.google.common.cache;Cache;true;getIfPresent;(Object);;MapValue of Argument[-1];ReturnValue;value",
        // the true flow to MapKey of ReturnValue for getAllPresent is the intersection of the these inputs, but intersections cannot be modelled fully accurately.
        "com.google.common.cache;Cache;true;getAllPresent;(Iterable);;MapKey of Argument[-1];MapKey of ReturnValue;value",
        "com.google.common.cache;Cache;true;getAllPresent;(Iterable);;Element of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.cache;Cache;true;getAllPresent;(Iterable);;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "com.google.common.cache;Cache;true;put;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "com.google.common.cache;Cache;true;put;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "com.google.common.cache;Cache;true;putAll;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "com.google.common.cache;Cache;true;putAll;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "com.google.common.cache;LoadingCache;true;get;(Object);;MapValue of Argument[-1];ReturnValue;value",
        "com.google.common.cache;LoadingCache;true;getUnchecked;(Object);;MapValue of Argument[-1];ReturnValue;value",
        "com.google.common.cache;LoadingCache;true;apply;(Object);;MapValue of Argument[-1];ReturnValue;value",
        "com.google.common.cache;LoadingCache;true;getAll;(Iterable);;Element of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.cache;LoadingCache;true;getAll;(Iterable);;Element of Argument[0];MapKey of Argument[-1];value",
        "com.google.common.cache;LoadingCache;true;getAll;(Iterable);;MapValue of Argument[-1];MapValue of ReturnValue;value"
      ]
  }
}
