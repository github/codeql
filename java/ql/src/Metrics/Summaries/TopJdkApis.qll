/** Provides classes and predicates for working with Top JDK APIs. */

import java
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
      "java.lang.String#charAt(int)",
      "java.lang.UnsupportedOperationException#UnsupportedOperationException(String)",
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
      "java.util.HashMap#HashMap(Map)", "java.util.function.BiConsumer#accept(Object,Object)",
      // top 400 JDK APIs
      "java.util.HashMap#containsKey(Object)", "java.util.Collection#contains(Object)",
      "java.lang.Double#parseDouble(String)", "java.lang.Thread#interrupt()",
      "java.awt.Container#add(Component)", "java.time.chrono.ChronoZonedDateTime#toInstant()",
      "java.util.List#subList(int,int)", "java.util.concurrent.ConcurrentHashMap#get(Object)",
      "java.lang.System#getenv(String)", "java.time.Duration#ofMillis(long)",
      "java.lang.Integer#toString()", "java.lang.reflect.Constructor#newInstance(Object[])",
      "java.util.Hashtable#get(Object)", "java.lang.Class#toString()",
      "java.util.Vector#add(Object)", "java.io.StringReader#StringReader(String)",
      "java.io.File#getPath()", "java.lang.System#identityHashCode(Object)",
      "java.util.stream.Stream#count()", "java.util.concurrent.CompletableFuture#complete(Object)",
      "java.nio.file.Files#exists(Path,LinkOption[])", "java.util.List#set(int,Object)",
      "java.util.concurrent.atomic.AtomicLong#AtomicLong(long)",
      "java.util.Optional#orElseGet(Supplier)", "java.lang.Class#forName(String)",
      "java.lang.String#replace(char,char)", "java.util.Enumeration#nextElement()",
      "java.lang.Class#getMethod(String,Class[])", "java.nio.file.Path#toAbsolutePath()",
      "java.util.Enumeration#hasMoreElements()", "java.lang.Class#cast(Object)",
      "java.util.concurrent.atomic.AtomicBoolean#AtomicBoolean(boolean)",
      "java.math.BigDecimal#doubleValue()", "java.util.UUID#fromString(String)",
      "java.lang.System#exit(int)", "java.util.List#add(int,Object)",
      "java.lang.Boolean#valueOf(boolean)", "java.sql.Timestamp#getTime()",
      "java.nio.Buffer#remaining()", "java.net.URL#URL(String)", "java.net.URI#URI(String)",
      "java.util.Objects#hashCode(Object)", "java.util.Set#clear()", "java.io.File#isDirectory()",
      "java.time.Duration#toMillis()", "java.nio.ByteBuffer#allocate(int)",
      "java.math.BigDecimal#toString()", "java.lang.Class#getResourceAsStream(String)",
      "java.util.logging.Logger#getLogger(String)", "java.lang.String#toLowerCase(Locale)",
      "java.util.concurrent.CompletableFuture#completeExceptionally(Throwable)",
      "java.util.stream.Stream#findAny()",
      "java.util.concurrent.CompletableFuture#completedFuture(Object)",
      "java.util.stream.Stream#of(Object)", "java.util.Map#of(Object,Object,Object,Object)",
      "java.util.Collections#sort(List,Comparator)", "java.lang.Thread#Thread(Runnable)",
      "java.lang.String#lastIndexOf(int)",
      "java.io.UncheckedIOException#UncheckedIOException(IOException)",
      "java.util.LinkedHashSet#LinkedHashSet(Collection)",
      "java.sql.PreparedStatement#executeUpdate()", "java.time.ZoneId#of(String)",
      "java.util.concurrent.atomic.AtomicLong#addAndGet(long)", "java.nio.ByteBuffer#wrap(byte[])",
      "java.util.List#indexOf(Object)", "java.util.Collections#unmodifiableMap(Map)",
      "java.lang.Long#Long(long)", "java.util.StringTokenizer#nextToken()",
      "java.lang.String#join(CharSequence,CharSequence[])", "java.io.StringWriter#toString()",
      "java.lang.Integer#toHexString(int)", "java.lang.Long#intValue()",
      "java.text.MessageFormat#format(String,Object[])",
      "java.lang.Exception#Exception(String,Throwable)",
      "java.util.stream.Stream#toArray(IntFunction)", "java.util.List#sort(Comparator)",
      "java.util.LinkedHashMap#get(Object)", "java.sql.PreparedStatement#setLong(int,long)",
      "java.lang.Iterable#iterator()", "java.math.BigInteger#or(BigInteger)",
      "java.time.LocalDateTime#of(int,int,int,int,int,int)", "java.time.Instant#toEpochMilli()",
      "java.math.BigDecimal#setScale(int,RoundingMode)", "java.lang.Class#isInstance(Object)",
      "java.util.regex.Pattern#compile(String)", "java.util.Calendar#getTimeInMillis()",
      "java.lang.Class#getResource(String)", "java.util.concurrent.Executor#execute(Runnable)",
      "java.util.concurrent.locks.Lock#unlock()", "java.lang.AssertionError#AssertionError(Object)",
      "java.util.ArrayList#addAll(Collection)", "java.io.File#mkdirs()",
      "java.time.Duration#ofMinutes(long)", "java.time.format.DateTimeFormatter#ofPattern(String)",
      "java.lang.Throwable#getLocalizedMessage()", "java.lang.StringBuilder#delete(int,int)",
      "java.util.Vector#size()", "java.lang.String#String(String)", "java.util.ArrayList#isEmpty()",
      "java.util.Collection#removeIf(Predicate)",
      // top 500 JDK APIs
      "java.util.HashSet#HashSet(int)", "java.util.Set#of(Object,Object)",
      "java.util.Collections#unmodifiableSet(Set)", "java.sql.Connection#createStatement()",
      "java.math.BigDecimal#subtract(BigDecimal)", "java.util.Date#from(Instant)",
      "java.lang.StringBuffer#append(char)", "java.util.Locale#forLanguageTag(String)",
      "java.io.DataInput#readLong()", "java.util.Collections#sort(List)",
      "java.io.DataOutput#writeLong(long)", "java.util.function.BiFunction#apply(Object,Object)",
      "java.lang.String#lastIndexOf(String)", "java.util.Optional#filter(Predicate)",
      "java.lang.StringBuffer#append(Object)", "java.io.File#getParentFile()",
      "java.util.stream.Stream#allMatch(Predicate)", "java.sql.ResultSet#getTimestamp(String)",
      "java.util.Calendar#setTime(Date)",
      "java.util.concurrent.CompletionStage#toCompletableFuture()",
      "java.util.concurrent.locks.Lock#lock()", "java.lang.reflect.Field#get(Object)",
      "java.io.InputStream#close()", "java.math.BigInteger#BigInteger(String)",
      "java.lang.Class#getDeclaredField(String)",
      "java.io.InputStreamReader#InputStreamReader(InputStream)", "java.lang.Runtime#getRuntime()",
      "java.lang.Class#getDeclaredConstructor(Class[])",
      "java.lang.AbstractStringBuilder#setLength(int)", "java.nio.Buffer#position()",
      "java.nio.file.Path#getFileName()", "java.util.List#toArray()",
      "java.lang.CharSequence#length()", "java.util.stream.Stream#distinct()",
      "java.net.URL#toURI()", "java.util.Queue#poll()", "java.lang.Thread#getContextClassLoader()",
      "java.lang.String#valueOf(boolean)", "java.util.Calendar#add(int,int)",
      "java.util.HashMap#entrySet()", "java.util.stream.IntStream#mapToObj(IntFunction)",
      "java.util.concurrent.atomic.AtomicLong#incrementAndGet()",
      "java.util.concurrent.ExecutorService#shutdown()",
      "java.util.concurrent.ExecutorService#submit(Runnable)", "java.math.BigDecimal#intValue()",
      "java.math.BigDecimal#toBigInteger()", "java.util.LinkedList#add(Object)",
      "java.lang.AbstractStringBuilder#charAt(int)", "java.lang.Thread#getName()",
      "java.lang.Math#max(long,long)", "java.util.HashMap#size()",
      "java.time.LocalDate#plusDays(long)", "java.nio.ByteBuffer#array()",
      "java.lang.StringBuilder#append(CharSequence)", "java.util.Vector#addElement(Object)",
      "java.lang.ClassLoader#getResource(String)", "java.awt.Insets#Insets(int,int,int,int)",
      "java.util.TimeZone#getTimeZone(String)", "java.time.ZoneId#systemDefault()",
      "java.lang.Number#doubleValue()", "java.util.stream.Stream#reduce(Object,BinaryOperator)",
      "java.lang.CharSequence#toString()", "java.time.Instant#parse(CharSequence)",
      "java.text.Format#format(Object)", "java.io.File#toURI()", "java.sql.ResultSet#getInt(int)",
      "java.lang.Number#longValue()", "java.lang.Double#doubleToLongBits(double)",
      "java.lang.Math#min(long,long)", "java.lang.Double#valueOf(double)",
      "java.lang.invoke.MethodHandles#lookup()", "java.util.concurrent.CompletableFuture#isDone()",
      "java.time.LocalDate#parse(CharSequence)", "java.lang.StringBuilder#append(boolean)",
      "java.util.concurrent.CountDownLatch#await()",
      "java.util.concurrent.ConcurrentHashMap#put(Object,Object)",
      "java.util.stream.Stream#mapToInt(ToIntFunction)",
      "java.math.BigDecimal#multiply(BigDecimal)", "java.util.stream.Stream#concat(Stream,Stream)",
      "java.time.Instant#ofEpochMilli(long)", "java.nio.file.Path#getParent()",
      "java.util.stream.Stream#sorted()",
      "java.util.concurrent.atomic.AtomicBoolean#compareAndSet(boolean,boolean)",
      "java.util.UUID#equals(Object)", "java.io.OutputStream#flush()",
      "java.time.format.DateTimeFormatter#format(TemporalAccessor)", "java.io.Closeable#close()",
      "java.util.EventObject#getSource()", "java.io.File#File(String,String)",
      "java.lang.Number#intValue()", "java.io.File#length()",
      "java.lang.AbstractStringBuilder#setCharAt(int,char)", "java.util.Set#removeAll(Collection)",
      "java.io.File#listFiles()", "java.lang.ClassLoader#getResourceAsStream(String)",
      "java.util.Date#toInstant()", "java.util.Queue#add(Object)", "java.io.File#isFile()",
      "java.sql.Statement#close()", "java.io.DataOutput#writeBoolean(boolean)"
    ]
}

/** Holds if `c` has the MaD-formatted name `apiName`. */
predicate hasApiName(Callable c, string apiName) {
  apiName =
    c.getDeclaringType().getPackage() + "." + c.getDeclaringType().getSourceDeclaration() + "#" +
      c.getName() + paramsString(c)
}

/** A top JDK API. */
class TopJdkApi extends Callable {
  TopJdkApi() {
    this.isSourceDeclaration() and
    exists(string apiName |
      hasApiName(this, apiName) and
      topJdkApiName(apiName)
    )
  }

  /** Holds if this API has a manual summary model. */
  private predicate hasManualSummary() {
    exists(FlowSummaryImpl::Public::SummarizedCallable sc |
      sc.asCallable() = this and sc.hasManualModel()
    )
  }

  /** Holds if this API has a manual neutral summary model. */
  private predicate hasManualNeutralSummary() {
    this = any(FlowSummaryImpl::Public::NeutralSummaryCallable n | n.hasManualModel()).asCallable()
  }

  /** Holds if this API has a manual MaD model. */
  predicate hasManualMadModel() { this.hasManualSummary() or this.hasManualNeutralSummary() }
  /*
   * Note: the following top JDK APIs are not modeled with MaD:
   * `java.lang.Runnable#run()`: specialised lambda flow
   * `java.lang.String#valueOf(Object)`: a complex case; an alias for `Object.toString`, except the dispatch is hidden
   * `java.lang.System#getProperty(String)`: needs to be modeled by regular CodeQL matching the get and set keys to reduce FPs
   * `java.lang.System#setProperty(String,String)`: needs to be modeled by regular CodeQL matching the get and set keys to reduce FPs
   * `java.lang.Throwable#printStackTrace()`: should probably not be a general step, but there might be specialised queries that care
   * `java.text.Format#format(Object)`: similar issue as `Object.toString`; depends on the object being passed as the argument
   * `java.text.MessageFormat#format(String,Object[])`: similar issue as `Object.toString`; depends on the object being passed as the argument
   * `java.util.Comparator#comparing(Function)`: lambda flow
   * `java.util.function.BiConsumer#accept(Object,Object)`: specialized lambda flow
   * `java.util.function.BiFunction#apply(Object,Object)`: specialized lambda flow
   * `java.util.function.Consumer#accept(Object)`: specialized lambda flow
   * `java.util.function.Function#apply(Object)`: specialized lambda flow
   * `java.util.function.Supplier#get()`: lambda flow
   * `java.util.stream.Collectors#joining(CharSequence)`: cannot be modeled completely without a model for `java.util.stream.Stream#collect(Collector)` as well
   * `java.util.stream.Collectors#toMap(Function,Function)`: specialized collectors flow
   * `java.util.stream.Stream#collect(Collector)`: handled separately on a case-by-case basis as it is too complex for MaD
   */

  }
