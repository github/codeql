/** Definitions of flow steps through the various string utility functions in the Guava framework. */

import java
private import semmle.code.java.dataflow.FlowSteps

/**
 * The class `com.google.common.base.Strings`.
 */
class TypeGuavaStrings extends Class {
  TypeGuavaStrings() { this.hasQualifiedName("com.google.common.base", "Strings") }
}

/**
 * The class `com.google.common.base.Joiner`.
 */
class TypeGuavaJoiner extends Class {
  TypeGuavaJoiner() { this.hasQualifiedName("com.google.common.base", "Joiner") }
}

/**
 * The nested class `Joiner.MapJoiner`.
 */
class TypeGuavaMapJoiner extends NestedClass {
  TypeGuavaMapJoiner() {
    this.getEnclosingType() instanceof TypeGuavaJoiner and
    this.hasName("MapJoiner")
  }
}

/**
 * The class `com.google.common.base.Splitter`.
 */
class TypeGuavaSplitter extends Class {
  TypeGuavaSplitter() { this.hasQualifiedName("com.google.common.base", "Splitter") }
}

/**
 * The nested class `Splitter.MapSplitter`.
 */
class TypeGuavaMapSplitter extends NestedClass {
  TypeGuavaMapSplitter() {
    this.getEnclosingType() instanceof TypeGuavaSplitter and
    this.hasName("MapSplitter")
  }
}

/**
 * A taint preserving method on `com.google.common.base.Strings`.
 */
private class GuavaStringsTaintPreservingMethod extends TaintPreservingCallable {
  GuavaStringsTaintPreservingMethod() {
    this.getDeclaringType() instanceof TypeGuavaStrings and
    // static String emptyToNull(String string)
    // static String nullToEmpty(String string)
    // static String padStart(String string, int minLength, char padChar)
    // static String padEnd(String string, int minLength, char padChar)
    // static String repeat(String string, int count)
    // static String lenientFormat(String template, Object ... args)
    this.hasName(["emptyToNull", "nullToEmpty", "padStart", "padEnd", "repeat", "lenientFormat"])
  }

  override predicate returnsTaintFrom(int src) {
    src = 0
    or
    this.hasName("lenientFormat") and
    src = [0 .. getNumberOfParameters()]
  }
}

/**
 * A method of `Joiner` or `MapJoiner`.
 */
private class GuavaJoinerMethod extends Method {
  GuavaJoinerMethod() {
    this.getDeclaringType().getASourceSupertype*() instanceof TypeGuavaJoiner or
    this.getDeclaringType().getASourceSupertype*() instanceof TypeGuavaMapJoiner
  }
}

/**
 * A method that builds a `Joiner` or `MapJoiner`.
 */
private class GuavaJoinerBuilderMethod extends GuavaJoinerMethod, TaintPreservingCallable {
  GuavaJoinerBuilderMethod() {
    // static Joiner on(char separator)
    // static Joiner on(String separator)
    // Joiner skipNulls()
    // Joiner useForNull(String nullText)
    // Joiner.MapJoiner withKeyValueSeparator(char keyValueSeparator)
    // Joiner.MapJoiner withKeyValueSeparator(String keyValueSeparator)
    // Joiner.MapJoiner useForNull(String nullText) [on MapJoiner]
    this.hasName(["on", "skipNulls", "useForNull", "withKeyValueSeparator"])
  }

  override predicate returnsTaintFrom(int src) {
    src = 0
    or
    src = -1 and not isStatic()
  }
}

/**
 * An `appendTo` method on `Joiner` or `MapJoiner`.
 */
private class GuavaJoinerAppendToMethod extends GuavaJoinerMethod, TaintPreservingCallable {
  GuavaJoinerAppendToMethod() {
    // <A extends Appendable> A appendTo(A appendable, Iterable<?> parts)
    // <A extends Appendable> A appendTo(A appendable, Iterator<?> parts)
    // <A extends Appendable> A appendTo(A appendable, Object[] parts)
    // <A extends Appendable> A appendTo(A appendable, Object first, Object second, Object... rest)
    // StringBuilder appendTo(StringBuilder builder, Iterable<?> parts)
    // StringBuilder appendTo(StringBuilder builder, Iterator<?> parts)
    // StringBuilder appendTo(StringBuilder builder, Object[] parts)
    // StringBuilder appendTo(StringBuilder builder, Object first, Object second, Object... rest)
    // <A extends Appendable> A appendTo(A appendable, Iterable<? extends Map.Entry<?,?>> entries) [on MapJoiner]
    // <A extends Appendable> A appendTo(A appendable, Iterator<? extends Map.Entry<?,?>> parts)
    // <A extends Appendable> A appendTo(A appendable, Map<?,?> map)
    // StringBuilder appendTo(StringBuilder builder, Iterable<? extends Map.Entry<?,?>> entries)
    // StringBuilder appendTo(StringBuilder builder, Iterator<? extends Map.Entry<?,?>> entries)
    // StringBuilder appendTo(StringBuilder builder, Map<?,?> map)
    this.hasName("appendTo")
  }

  override predicate transfersTaint(int src, int sink) {
    src = [-1 .. getNumberOfParameters()] and
    src != sink and
    sink = 0
  }

  override predicate returnsTaintFrom(int src) { src = [-1 .. getNumberOfParameters()] }
}

/**
 * A `join` method on `Joiner` or `MapJoiner`.
 */
private class GuavaJoinMethod extends GuavaJoinerMethod, TaintPreservingCallable {
  GuavaJoinMethod() {
    // String join(Iterable<?> parts)
    // String join(Iterator<?> parts)
    // String join(Object[] parts)
    // String join(Object first, Object second, Object... rest)
    // String join(Iterable<? extends Map.Entry<?,?>> entries) [on MapJoiner]
    // String join(Iterator<? extends Map.Entry<?,?>> entries)
    // String join(Map<?,?> map)
    this.hasName("join")
  }

  override predicate returnsTaintFrom(int src) { src = [-1 .. getNumberOfParameters()] }
}

/**
 * A method of `Splitter` or `MapSplitter` that splits its input string.
 */
private class GuavaSplitMethod extends TaintPreservingCallable {
  GuavaSplitMethod() {
    (
      this.getDeclaringType() instanceof TypeGuavaSplitter
      or
      this.getDeclaringType() instanceof TypeGuavaMapSplitter
    ) and
    // Iterable<String> split(CharSequence sequence)
    // List<String> splitToList(CharSequence sequence)
    // Stream<String> splitToStream(CharSequence sequence)
    // Map<String,String> split(CharSequence sequence) [on MapSplitter]
    this.hasName(["split", "splitToList", "splitToStream"])
  }

  override predicate returnsTaintFrom(int src) { src = 0 }
}
