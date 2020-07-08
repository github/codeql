import java
import semmle.code.java.Collections
import semmle.code.java.Maps

private class EntryType extends RefType {
  EntryType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.util", "Map<>$Entry")
  }

  RefType getValueType() {
    exists(GenericType t | t.hasQualifiedName("java.util", "Map<>$Entry") |
      indirectlyInstantiates(this, t, 1, result)
    )
  }
}

private class IterableType extends RefType {
  IterableType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.lang", "Iterable")
  }

  RefType getElementType() {
    exists(GenericType t | t.hasQualifiedName("java.lang", "Iterable") |
      indirectlyInstantiates(this, t, 0, result)
    )
  }
}

private class IteratorType extends RefType {
  IteratorType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.util", "Iterator")
  }

  RefType getElementType() {
    exists(GenericType t | t.hasQualifiedName("java.util", "Iterator") |
      indirectlyInstantiates(this, t, 0, result)
    )
  }
}

private class EnumerationType extends RefType {
  EnumerationType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.util", "Enumeration")
  }

  RefType getElementType() {
    exists(GenericType t | t.hasQualifiedName("java.util", "Enumeration") |
      indirectlyInstantiates(this, t, 0, result)
    )
  }
}

/**
 * A type that acts as a container. This includes collections, maps, iterators,
 * iterables, enumerations, and map entry pairs. For maps and map entry pairs
 * only the value component is considered to act as a container.
 */
class ContainerType extends RefType {
  ContainerType() {
    this instanceof EntryType or
    this instanceof IterableType or
    this instanceof IteratorType or
    this instanceof EnumerationType or
    this instanceof MapType or
    this instanceof CollectionType
  }

  /** Gets the type of the contained elements. */
  RefType getElementType() {
    result = this.(EntryType).getValueType() or
    result = this.(IterableType).getElementType() or
    result = this.(IteratorType).getElementType() or
    result = this.(EnumerationType).getElementType() or
    result = this.(MapType).getValueType() or
    result = this.(CollectionType).getElementType()
  }

  /**
   * Gets the type of the contained elements or its upper bound if the type is
   * a type variable or wildcard.
   */
  RefType getElementTypeBound() {
    exists(RefType e | e = this.getElementType() |
      result = e and not e instanceof BoundedType
      or
      result = e.(BoundedType).getAnUltimateUpperBoundType()
    )
  }
}

private predicate taintPreservingQualifierToMethod(Method m) {
  m.getDeclaringType() instanceof EntryType and
  m.hasName("getValue")
  or
  m.getDeclaringType() instanceof IterableType and
  m.hasName("iterator")
  or
  m.getDeclaringType() instanceof IteratorType and
  m.hasName("next")
  or
  m.getDeclaringType() instanceof EnumerationType and
  m.hasName("nextElement")
  or
  m.(MapMethod).hasName("entrySet")
  or
  m.(MapMethod).hasName("get")
  or
  m.(MapMethod).hasName("remove")
  or
  m.(MapMethod).hasName("values")
  or
  m.(CollectionMethod).hasName("toArray")
  or
  m.(CollectionMethod).hasName("get")
  or
  m.(CollectionMethod).hasName("remove") and m.getParameterType(0).(PrimitiveType).hasName("int")
  or
  m.(CollectionMethod).hasName("remove") and m.getNumberOfParameters() = 0
  or
  m.(CollectionMethod).hasName("subList")
  or
  m.(CollectionMethod).hasName("firstElement")
  or
  m.(CollectionMethod).hasName("lastElement")
  or
  m.(CollectionMethod).hasName("poll")
  or
  m.(CollectionMethod).hasName("peek")
  or
  m.(CollectionMethod).hasName("element")
}

private predicate qualifierToMethodStep(Expr tracked, MethodAccess sink) {
  taintPreservingQualifierToMethod(sink.getMethod()) and
  tracked = sink.getQualifier()
}

private predicate qualifierToArgumentStep(Expr tracked, RValue sink) {
  exists(MethodAccess ma |
    ma.getMethod().(CollectionMethod).hasName("toArray") and
    tracked = ma.getQualifier() and
    sink = ma.getArgument(1)
  )
}

private predicate taintPreservingArgumentToQualifier(Method method, int arg) {
  method.(MapMethod).hasName("put") and arg = 1
  or
  method.(MapMethod).hasName("putAll") and arg = 0
  or
  method.(CollectionMethod).hasName("add") and arg = method.getNumberOfParameters() - 1
  or
  method.(CollectionMethod).hasName("addAll") and arg = method.getNumberOfParameters() - 1
  or
  method.(CollectionMethod).hasName("addElement") and arg = 0
  or
  method.(CollectionMethod).hasName("set") and arg = 1
  or
  method.(CollectionMethod).hasName("offer") and arg = 0
}

/**
 * Holds if `method` is a library method that returns tainted data if its
 * `arg`th argument is tainted.
 */
private predicate taintPreservingArgumentToMethod(Method method, int arg) {
  method.getDeclaringType().hasQualifiedName("java.util", "Collections") and
  (
    method
        .hasName(["checkedCollection", "checkedList", "checkedMap", "checkedNavigableMap",
              "checkedNavigableSet", "checkedSet", "checkedSortedMap", "checkedSortedSet",
              "enumeration", "list", "max", "min", "singleton", "singletonList",
              "synchronizedCollection", "synchronizedList", "synchronizedMap",
              "synchronizedNavigableMap", "synchronizedNavigableSet", "synchronizedSet",
              "synchronizedSortedMap", "synchronizedSortedSet", "unmodifiableCollection",
              "unmodifiableList", "unmodifiableMap", "unmodifiableNavigableMap",
              "unmodifiableNavigableSet", "unmodifiableSet", "unmodifiableSortedMap",
              "unmodifiableSortedSet"]) and
    arg = 0
    or
    method.hasName(["nCopies", "singletonMap"]) and arg = 1
  )
  or
  method.getDeclaringType().hasQualifiedName("java.util", "Arrays") and
  (
    method.hasName(["copyOf", "copyOfRange", "spliterator", "stream"]) and
    arg = 0
  )
}

/**
 * Holds if `method` is a library method that writes tainted data to the
 * `output`th argument if the `input`th argument is tainted.
 */
private predicate taintPreservingArgToArg(Method method, int input, int output) {
  method.getDeclaringType().hasQualifiedName("java.util", "Collections") and
  (
    method.hasName(["copy", "fill"]) and
    input = 1 and
    output = 0
    or
    method.hasName("replaceAll") and input = 2 and output = 0
  )
  or
  method.getDeclaringType().hasQualifiedName("java.util", "Arrays") and
  (
    method.hasName("fill") and
    output = 0 and
    input = method.getNumberOfParameters() - 1
  )
}

private predicate argToQualifierStep(Expr tracked, Expr sink) {
  exists(Method m, int i, MethodAccess ma |
    taintPreservingArgumentToQualifier(m, i) and
    ma.getMethod() = m and
    tracked = ma.getArgument(i) and
    sink = ma.getQualifier()
  )
}

/** Access to a method that passes taint from an argument. */
private predicate argToMethodStep(Expr tracked, MethodAccess sink) {
  exists(Method m |
    m = sink.getMethod() and
    (
      exists(int i |
        taintPreservingArgumentToMethod(m, i) and
        tracked = sink.getArgument(i)
      )
      or
      m.getDeclaringType().hasQualifiedName("java.util", "Arrays") and
      m.hasName("asList") and
      tracked = sink.getAnArgument()
    )
  )
}

/**
 * Holds if `tracked` and `sink` are arguments to a method that transfers taint
 * between arguments.
 */
private predicate argToArgStep(Expr tracked, Expr sink) {
  exists(MethodAccess ma, Method method, int input, int output |
    ma.getMethod() = method and
    ma.getArgument(input) = tracked and
    ma.getArgument(output) = sink and
    (
      taintPreservingArgToArg(method, input, output)
      or
      method.getDeclaringType().hasQualifiedName("java.util", "Collections") and
      method.hasName("addAll") and
      input >= 1 and
      output = 0
    )
  )
}

/**
 * Holds if the step from `n1` to `n2` is either extracting a value from a
 * container, inserting a value into a container, or transforming one container
 * to another. This is restricted to cases where `n2` is the returned value of
 * a call.
 */
predicate containerReturnValueStep(Expr n1, Expr n2) {
  qualifierToMethodStep(n1, n2) or argToMethodStep(n1, n2)
}

/**
 * Holds if the step from `n1` to `n2` is either extracting a value from a
 * container, inserting a value into a container, or transforming one container
 * to another. This is restricted to cases where the value of `n2` is being modified.
 */
predicate containerUpdateStep(Expr n1, Expr n2) {
  qualifierToArgumentStep(n1, n2) or
  argToQualifierStep(n1, n2) or
  argToArgStep(n1, n2)
}

/**
 * Holds if the step from `n1` to `n2` is either extracting a value from a
 * container, inserting a value into a container, or transforming one container
 * to another.
 */
predicate containerStep(Expr n1, Expr n2) {
  containerReturnValueStep(n1, n2) or
  containerUpdateStep(n1, n2)
}
