import java
import Guava

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
 * A method of `Joiner` or `MapJoiner`.
 */
private class GuavaJoinerMethod extends Method {
  GuavaJoinerMethod() {
    this.getDeclaringType() instanceof TypeGuavaJoiner or
    this.getDeclaringType() instanceof TypeGuavaMapJoiner
  }
}

/**
 * A method that builds a `Joiner` or `MapJoiner`.
 */
class GuavaJoinerBuilderMethod extends GuavaJoinerMethod, GuavaTaintPropagationMethodToReturn {
  GuavaJoinerBuilderMethod() {
    // static Joiner on(char separator)
    // static Joiner on(String separator)
    // Joiner skipNulls()
    // Joiner useForNull(String nullText)
    // Joiner.MapJoiner withKeyValueSeparator(String keyValueSeparator)
    // Joiner.MapJoiner useForNull(String nullText) [on MapJoiner]
    this.hasName(["on", "skipNulls", "useForNull", "withKeyValueSeparator"])
  }

  override predicate propagatesTaint(int src) { src = [-1, 0] }
}

/**
 * An `appendTo` method on `Joiner` or `MapJoiner`
 */
class GuavaJoinerAppendToMethod extends GuavaJoinerMethod, GuavaTaintPropagationMethod {
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

  override predicate propagatesTaint(int src, int sink) {
    src = [-1 .. getNumberOfParameters()] and
    src != sink and
    sink = [-2, 0]
  }
}

/**
 * A `join` method on `Joiner` or `MapJoiner`
 */
class GuavaJoinMethod extends GuavaJoinerMethod, GuavaTaintPropagationMethodToReturn {
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

  override predicate propagatesTaint(int src) { src = [-1 .. getNumberOfParameters()] }
}
