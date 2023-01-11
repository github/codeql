/** Provides classes and predicates for working with Top JDK APIs. */

import java
private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.java.dataflow.ExternalFlow

/** Holds if the given API name is a top JDK API. */
predicate topJdkApiName(string apiName) {
  apiName in [
      // top 100 JDK APIs
      "java.lang.StringBuilder#append(String)", "java.util.List#get(int)",
      "java.util.List#add(Object)", "java.util.Map#put(Object,Object)",
      "java.lang.String#equals(Object)", "java.util.Map#get(Object)", "java.util.List#size()",
      "java.util.Collection#stream()", "java.lang.Object#getClass()",
      "java.util.stream.Stream#collect(Collector)", "java.util.Objects#equals(Object,Object)",
      "java.lang.String#format(String,Object[])", "java.util.stream.Stream#map(Function)",
      "java.lang.Throwable#getMessage()", "java.util.Arrays#asList(Object[])",
      "java.lang.String#equalsIgnoreCase(String)", "java.util.List#isEmpty()",
      "java.util.Set#add(Object)", "java.util.HashMap#put(Object,Object)",
      "java.util.stream.Collectors#toList()", "java.lang.StringBuilder#append(char)",
      "java.util.stream.Stream#filter(Predicate)", "java.lang.String#length()",
      "java.lang.Enum#name()", "java.lang.Object#toString()", "java.util.Optional#get()",
      "java.lang.StringBuilder#toString()",
      "java.lang.IllegalArgumentException#IllegalArgumentException(String)",
      "java.lang.Class#getName()", "java.lang.Enum#Enum(String,int)",
      "java.io.PrintWriter#write(String)", "java.util.Entry#getValue()", "java.util.Entry#getKey()",
      "java.util.Iterator#next()", "java.lang.Object#hashCode()",
      "java.util.Optional#orElse(Object)", "java.lang.StringBuffer#append(String)",
      "java.util.Collections#singletonList(Object)", "java.lang.Iterable#forEach(Consumer)",
      "java.util.Optional#of(Object)", "java.lang.String#contains(CharSequence)",
      "java.util.ArrayList#add(Object)", "java.util.Optional#ofNullable(Object)",
      "java.util.Collections#emptyList()", "java.math.BigDecimal#BigDecimal(String)",
      "java.lang.System#currentTimeMillis()", "java.lang.Object#equals(Object)",
      "java.util.Map#containsKey(Object)", "java.util.Optional#isPresent()",
      "java.lang.String#trim()", "java.util.List#addAll(Collection)",
      "java.util.Set#contains(Object)", "java.util.Optional#map(Function)",
      "java.util.Map#entrySet()", "java.util.Optional#empty()",
      "java.lang.Integer#parseInt(String)", "java.lang.String#startsWith(String)",
      "java.lang.IllegalStateException#IllegalStateException(String)",
      "java.lang.Enum#equals(Object)", "java.util.Iterator#hasNext()",
      "java.util.List#contains(Object)", "java.lang.String#substring(int,int)",
      "java.util.List#of(Object)", "java.util.Objects#hash(Object[])",
      "java.lang.RuntimeException#RuntimeException(String)", "java.lang.String#isEmpty()",
      "java.lang.String#replace(CharSequence,CharSequence)", "java.util.Set#size()",
      "java.io.File#File(String)", "java.lang.StringBuilder#append(Object)",
      "java.lang.String#split(String)", "java.util.Map#values()", "java.util.UUID#randomUUID()",
      "java.util.ArrayList#ArrayList(Collection)", "java.util.Map#keySet()",
      "java.sql.ResultSet#getString(String)", "java.lang.String#hashCode()",
      "java.lang.Throwable#Throwable(Throwable)", "java.util.HashMap#get(Object)",
      "java.lang.Class#getSimpleName()", "java.util.Set#isEmpty()", "java.util.Map#size()",
      "java.lang.String#substring(int)", "java.util.Map#remove(Object)",
      "java.lang.Throwable#printStackTrace()", "java.util.stream.Stream#findFirst()",
      "java.util.Optional#ifPresent(Consumer)", "java.lang.String#valueOf(Object)",
      "java.lang.String#toLowerCase()", "java.util.UUID#toString()",
      "java.lang.StringBuilder#append(int)", "java.util.Objects#requireNonNull(Object,String)",
      "java.nio.file.Path#resolve(String)", "java.lang.Enum#toString()",
      "java.lang.RuntimeException#RuntimeException(Throwable)", "java.util.Collection#size()",
      "java.lang.String#charAt(int)", "java.util.stream.Stream#forEach(Consumer)",
      "java.util.Map#isEmpty()", "java.lang.String#valueOf(int)"
    ]
}

/** Holds if `c` has the MaD-formatted name `apiName`. */
predicate hasApiName(Callable c, string apiName) {
  apiName =
    c.getDeclaringType().getPackage() + "." + c.getDeclaringType().getSourceDeclaration() + "#" +
      c.getName() + paramsString(c)
}

/** A top JDK API. */
class TopJdkApi extends SummarizedCallableBase {
  TopJdkApi() {
    exists(string apiName |
      hasApiName(this.asCallable(), apiName) and
      topJdkApiName(apiName)
    )
  }

  /** Holds if this API has a manual summary model. */
  private predicate hasManualSummary() { this.(SummarizedCallable).hasProvenance(false) }

  /** Holds if this API has a manual neutral model. */
  private predicate hasManualNeutral() {
    this.(FlowSummaryImpl::Public::NeutralCallable).hasProvenance(false)
  }

  /** Holds if this API has a manual MaD model. */
  predicate hasManualMadModel() { this.hasManualSummary() or this.hasManualNeutral() }
  /*
   * Note: the following top-100 APIs are not modeled with MaD:
   * java.util.stream.Stream#collect(Collector) : handled separately on a case-by-case basis as it is too complex for MaD
   * java.lang.String#valueOf(Object) : also a complex case; an alias for `Object.toString`, except the dispatch is hidden
   * java.lang.Throwable#printStackTrace() : should probably not be a general step, but there might be specialised queries that care
   */

  }
