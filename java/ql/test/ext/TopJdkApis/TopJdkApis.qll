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
      "java.util.Map#isEmpty()", "java.lang.String#valueOf(int)",
      // top 200 JDK APIs
      "java.lang.Integer#intValue()", "java.util.ArrayList#size()",
      "java.util.ArrayList#ArrayList(int)", "java.util.function.Function#apply(Object)",
      "java.util.stream.Stream#forEach(Consumer)", "java.util.ArrayList#get(int)",
      "java.util.Set#iterator()", "java.util.stream.Collectors#toSet()",
      "java.lang.String#replaceAll(String,String)", "java.lang.String#getBytes(Charset)",
      "java.util.Objects#requireNonNull(Object)", "java.util.Objects#nonNull(Object)",
      "java.lang.String#endsWith(String)", "java.lang.AbstractStringBuilder#length()",
      "java.sql.PreparedStatement#setString(int,String)",
      "java.util.regex.Pattern#matcher(CharSequence)", "java.nio.file.Path#toString()",
      "java.time.Instant#now()", "java.io.File#getAbsolutePath()",
      "java.util.Set#addAll(Collection)", "java.lang.Integer#valueOf(int)",
      "java.util.HashSet#HashSet(Collection)", "java.lang.Integer#toString(int)",
      "java.lang.StringBuilder#StringBuilder(String)", "java.lang.Thread#sleep(long)",
      "java.lang.Thread#currentThread()", "java.util.Date#getTime()",
      "java.io.Writer#write(String)", "java.lang.String#getBytes()", "java.io.File#exists()",
      "java.lang.String#toUpperCase()", "java.lang.Long#parseLong(String)",
      "java.util.Collections#emptyMap()", "java.util.Optional#orElseThrow(Supplier)",
      "java.util.List#of(Object,Object)", "java.util.concurrent.CountDownLatch#countDown()",
      "java.lang.Class#isAssignableFrom(Class)",
      "java.lang.IndexOutOfBoundsException#IndexOutOfBoundsException(String)",
      "java.lang.Throwable#getCause()", "java.util.Arrays#stream(Object[])",
      "java.util.function.Supplier#get()", "java.lang.Exception#Exception(String)",
      "java.util.function.Consumer#accept(Object)", "java.util.stream.Stream#anyMatch(Predicate)",
      "java.util.List#clear()", "java.io.File#File(File,String)",
      "java.lang.String#indexOf(String)", "java.util.List#iterator()",
      "java.util.concurrent.CountDownLatch#CountDownLatch(int)", "java.sql.ResultSet#next()",
      "java.sql.PreparedStatement#setInt(int,int)",
      "java.util.concurrent.atomic.AtomicInteger#get()",
      "java.util.stream.Collectors#toMap(Function,Function)", "java.lang.Math#min(int,int)",
      "java.lang.Long#equals(Object)", "java.util.Properties#setProperty(String,String)",
      "java.util.Map#getOrDefault(Object,Object)", "java.lang.System#getProperty(String)",
      "java.util.stream.Stream#of(Object[])", "java.nio.file.Paths#get(String,String[])",
      "java.math.BigDecimal#compareTo(BigDecimal)", "java.math.BigDecimal#valueOf(long)",
      "java.lang.RuntimeException#RuntimeException(String,Throwable)",
      "java.util.Collection#add(Object)", "java.util.Collections#emptySet()",
      "java.util.stream.Stream#flatMap(Function)",
      "java.util.concurrent.atomic.AtomicReference#get()", "java.util.Collection#isEmpty()",
      "java.lang.StringBuffer#toString()", "java.util.Collections#singleton(Object)",
      "java.io.File#getName()", "java.time.ZonedDateTime#now()",
      "java.io.ByteArrayInputStream#ByteArrayInputStream(byte[])", "java.nio.file.Path#toFile()",
      "java.util.Date#Date(long)", "java.lang.System#nanoTime()",
      "java.util.Hashtable#put(Object,Object)", "java.util.Map#putAll(Map)",
      "java.lang.Long#toString()", "java.util.List#toArray(Object[])", "java.io.File#toPath()",
      "java.util.regex.Matcher#group(int)", "java.time.LocalDate#of(int,int,int)",
      "java.lang.String#valueOf(long)", "java.math.BigDecimal#valueOf(double)",
      "java.io.IOException#IOException(String)", "java.text.DateFormat#format(Date)",
      "java.sql.ResultSet#getInt(String)", "java.util.Map#clear()", "java.util.HashSet#add(Object)",
      "java.lang.Class#getClassLoader()", "java.lang.Boolean#equals(Object)",
      "java.lang.String#concat(String)", "java.util.Collections#singletonMap(Object,Object)",
      "java.util.Collection#iterator()", "java.util.Map#computeIfAbsent(Object,Function)",
      "java.text.SimpleDateFormat#SimpleDateFormat(String)",
      "java.util.StringJoiner#add(CharSequence)", "java.lang.Long#longValue()",
      "java.util.stream.Collectors#joining(CharSequence)",
      // top 300 JDK APIs
      "java.lang.Math#max(int,int)", "java.util.Map#of(Object,Object)",
      "java.lang.Long#valueOf(long)", "java.util.Random#nextInt(int)",
      "java.lang.Long#valueOf(String)", "java.util.concurrent.CountDownLatch#await(long,TimeUnit)",
      "java.util.Properties#getProperty(String)", "java.util.Optional#isEmpty()",
      "java.util.concurrent.CompletableFuture#get()", "java.util.Objects#isNull(Object)",
      "java.lang.StringBuilder#append(long)", "java.awt.Container#add(Component,Object)",
      "java.math.BigDecimal#add(BigDecimal)", "java.sql.PreparedStatement#executeQuery()",
      "java.lang.StringBuilder#StringBuilder(int)", "java.util.Map#forEach(BiConsumer)",
      "java.math.BigDecimal#BigDecimal(int)", "java.util.Collections#unmodifiableList(List)",
      "java.util.Properties#put(Object,Object)", "java.sql.Timestamp#Timestamp(long)",
      "java.util.List#equals(Object)", "java.lang.String#indexOf(int)",
      "java.lang.Long#toString(long)", "java.lang.Integer#Integer(int)",
      "java.util.concurrent.atomic.AtomicBoolean#get()",
      "java.lang.System#setProperty(String,String)", "java.util.concurrent.Future#get()",
      "java.lang.Thread#start()", "java.util.Set#of(Object)", "java.util.Calendar#set(int,int)",
      "java.time.Duration#ofSeconds(long)", "java.lang.System#arraycopy(Object,int,Object,int,int)",
      "java.net.URI#toString()", "java.util.concurrent.atomic.AtomicInteger#incrementAndGet()",
      "java.util.Set#remove(Object)", "java.lang.Boolean#parseBoolean(String)",
      "java.util.Calendar#getTime()", "java.nio.charset.Charset#name()",
      "java.lang.ThreadLocal#get()", "java.lang.Class#getCanonicalName()",
      "java.util.List#remove(Object)", "java.lang.Throwable#toString()",
      "java.util.stream.Stream#toList()", "java.io.ByteArrayOutputStream#toByteArray()",
      "java.util.concurrent.atomic.AtomicLong#get()",
      "java.lang.NullPointerException#NullPointerException(String)", "java.util.List#of()",
      "java.util.Calendar#getInstance()", "java.util.Calendar#get(int)",
      "java.util.Optional#orElseThrow()", "java.lang.System#lineSeparator()",
      "java.lang.Boolean#booleanValue()", "java.util.logging.Logger#isLoggable(Level)",
      "java.lang.Enum#hashCode()", "java.util.List#hashCode()",
      "java.lang.reflect.Method#invoke(Object,Object[])", "java.lang.String#String(byte[],Charset)",
      "java.util.Comparator#comparing(Function)", "java.util.Arrays#toString(Object[])",
      "java.time.LocalDate#now()", "java.util.function.Function#identity()",
      "java.io.OutputStream#write(byte[])", "java.lang.Integer#equals(Object)",
      "java.io.BufferedReader#BufferedReader(Reader)", "java.io.DataInput#readInt()",
      "java.io.BufferedReader#readLine()", "java.util.Map#entry(Object,Object)",
      "java.lang.Runnable#run()", "java.util.ResourceBundle#getString(String)",
      "java.util.Iterator#remove()", "java.lang.String#join(CharSequence,Iterable)",
      "java.util.concurrent.atomic.AtomicBoolean#set(boolean)", "java.time.LocalDateTime#now()",
      "java.sql.ResultSet#getLong(String)", "java.text.DateFormat#parse(String)",
      "java.lang.String#toString()", "java.lang.Integer#valueOf(String)",
      "java.util.regex.Matcher#find()", "java.io.DataOutput#writeInt(int)",
      "java.util.HashMap#HashMap(int)", "java.util.stream.Stream#sorted(Comparator)",
      "java.lang.String#toCharArray()",
      "java.util.concurrent.atomic.AtomicInteger#AtomicInteger(int)",
      "java.lang.String#String(byte[])", "java.lang.reflect.Method#getName()",
      "java.sql.ResultSet#getString(int)", "java.net.URI#create(String)",
      "java.lang.Enum#ordinal()", "java.util.concurrent.atomic.AtomicReference#set(Object)",
      "java.util.concurrent.CompletableFuture#join()",
      "java.io.FileInputStream#FileInputStream(File)", "java.io.File#delete()",
      "java.util.concurrent.TimeUnit#toMillis(long)", "java.util.List#of(Object,Object,Object)",
      "java.lang.String#compareTo(String)", "java.util.stream.IntStream#range(int,int)",
      "java.math.BigInteger#valueOf(long)", "java.util.List#remove(int)",
      "java.util.HashMap#HashMap(Map)", "java.util.function.BiConsumer#accept(Object,Object)"
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
  private predicate hasManualSummary() { this.(SummarizedCallable).isManual() }

  /** Holds if this API has a manual neutral model. */
  private predicate hasManualNeutral() {
    this.(FlowSummaryImpl::Public::NeutralCallable).isManual()
  }

  /** Holds if this API has a manual MaD model. */
  predicate hasManualMadModel() { this.hasManualSummary() or this.hasManualNeutral() }
  /*
   * Note: the following top JDK APIs are not modeled with MaD:
   * `java.lang.String#valueOf(Object)`: a complex case; an alias for `Object.toString`, except the dispatch is hidden
   * `java.lang.System#getProperty(String)`: needs to be modeled by regular CodeQL matching the get and set keys to reduce FPs
   * `java.lang.Throwable#printStackTrace()`: should probably not be a general step, but there might be specialised queries that care
   * `java.util.function.Consumer#accept(Object)`: specialized lambda flow
   * `java.util.function.Function#apply(Object)`: specialized lambda flow
   * `java.util.function.Supplier#get()`: lambda flow
   * `java.util.stream.Collectors#joining(CharSequence)`: cannot be modeled completely without a model for `java.util.stream.Stream#collect(Collector)` as well
   * `java.util.stream.Collectors#toMap(Function,Function)`: specialized collectors flow
   * `java.util.stream.Stream#collect(Collector)`: handled separately on a case-by-case basis as it is too complex for MaD
   */

  }
