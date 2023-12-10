import java
import semmle.code.java.Collections
import semmle.code.java.Maps
private import semmle.code.java.dataflow.SSA
private import DataFlowUtil

private class EntryType extends RefType {
  EntryType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName("java.util", "Map$Entry")
  }

  RefType getValueType() {
    exists(GenericType t | t.hasQualifiedName("java.util", "Map$Entry") |
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
  // java.util.Map.Entry
  m.getDeclaringType() instanceof EntryType and
  m.hasName(["getValue", "setValue"])
  or
  // java.util.Iterable
  m.getDeclaringType() instanceof IterableType and
  m.hasName(["iterator", "spliterator"])
  or
  // java.util.Iterator
  m.getDeclaringType() instanceof IteratorType and
  m.hasName("next")
  or
  // java.util.ListIterator
  m.getDeclaringType() instanceof IteratorType and
  m.hasName("previous")
  or
  // java.util.Enumeration
  m.getDeclaringType() instanceof EnumerationType and
  m.hasName(["asIterator", "nextElement"])
  or
  // java.util.Map
  m.(MapMethod)
      .hasName([
          "computeIfAbsent", "entrySet", "get", "getOrDefault", "put", "putIfAbsent", "remove",
          "replace", "values"
        ])
  or
  // java.util.Collection
  m.(CollectionMethod).hasName(["parallelStream", "stream", "toArray"])
  or
  // java.util.List
  m.(CollectionMethod).hasName(["get", "listIterator", "set", "subList"])
  or
  m.(CollectionMethod).hasName("remove") and m.getParameterType(0).(PrimitiveType).hasName("int")
  or
  // java.util.Vector
  m.(CollectionMethod).hasName(["elementAt", "elements", "firstElement", "lastElement"])
  or
  // java.util.Stack
  m.(CollectionMethod).hasName(["peek", "pop"])
  or
  // java.util.Queue
  // covered by Stack: peek()
  m.(CollectionMethod).hasName(["element", "poll"])
  or
  m.(CollectionMethod).hasName("remove") and m.getNumberOfParameters() = 0
  or
  // java.util.Deque
  m.(CollectionMethod)
      .hasName([
          "getFirst", "getLast", "peekFirst", "peekLast", "pollFirst", "pollLast", "removeFirst",
          "removeLast"
        ])
  or
  // java.util.concurrent.BlockingQueue
  // covered by Queue: poll(long, TimeUnit)
  m.(CollectionMethod).hasName("take")
  or
  // java.util.concurrent.BlockingDeque
  // covered by Deque: pollFirst(long, TimeUnit), pollLast(long, TimeUnit)
  m.(CollectionMethod).hasName(["takeFirst", "takeLast"])
  or
  // java.util.SortedSet
  m.(CollectionMethod).hasName(["first", "headSet", "last", "subSet", "tailSet"])
  or
  // java.util.NavigableSet
  // covered by Deque: pollFirst(), pollLast()
  // covered by SortedSet: headSet(E, boolean), subSet(E, boolean, E, boolean) and tailSet(E, boolean)
  m.(CollectionMethod)
      .hasName(["ceiling", "descendingIterator", "descendingSet", "floor", "higher", "lower"])
  or
  // java.util.SortedMap
  m.(MapMethod).hasName(["headMap", "subMap", "tailMap"])
  or
  // java.util.NavigableMap
  // covered by SortedMap: headMap(K, boolean), subMap(K, boolean, K, boolean), tailMap(K, boolean)
  m.(MapMethod)
      .hasName([
          "ceilingEntry", "descendingMap", "firstEntry", "floorEntry", "higherEntry", "lastEntry",
          "lowerEntry", "pollFirstEntry", "pollLastEntry"
        ])
  or
  // java.util.Dictionary
  m.getDeclaringType()
      .getSourceDeclaration()
      .getASourceSupertype*()
      .hasQualifiedName("java.util", "Dictionary") and
  m.hasName(["elements", "get", "put", "remove"])
  or
  // java.util.concurrent.ConcurrentHashMap
  m.(MapMethod).hasName(["elements", "search", "searchEntries", "searchValues"])
}

private predicate qualifierToMethodStep(Expr tracked, MethodCall sink) {
  taintPreservingQualifierToMethod(sink.getMethod()) and
  tracked = sink.getQualifier()
}

private predicate qualifierToArgumentStep(Expr tracked, Expr sink) {
  exists(MethodCall ma, CollectionMethod method |
    method = ma.getMethod() and
    (
      // java.util.Vector
      method.hasName("copyInto")
      or
      // java.util.concurrent.BlockingQueue
      method.hasName("drainTo")
      or
      // java.util.Collection
      method.hasName("toArray") and method.getParameter(0).getType() instanceof Array
    ) and
    tracked = ma.getQualifier() and
    sink = ma.getArgument(0)
  )
}

private predicate taintPreservingArgumentToQualifier(Method method, int arg) {
  // java.util.Map.Entry
  method.getDeclaringType() instanceof EntryType and
  method.hasName("setValue") and
  arg = 0
  or
  // java.util.Map
  method.(MapMethod).hasName(["merge", "put", "putIfAbsent"]) and arg = 1
  or
  method.(MapMethod).hasName("replace") and arg = method.getNumberOfParameters() - 1
  or
  method.(MapMethod).hasName("putAll") and arg = 0
  or
  // java.util.ListIterator
  method.getDeclaringType() instanceof IteratorType and
  method.hasName(["add", "set"]) and
  arg = 0
  or
  // java.util.Collection
  method.(CollectionMethod).hasName(["add", "addAll"]) and
  // Refer to the last parameter to also cover List::add(int, E) and List::addAll(int, Collection)
  arg = method.getNumberOfParameters() - 1
  or
  // java.util.List
  // covered by Collection: add(int, E), addAll(int, Collection<? extends E>)
  method.(CollectionMethod).hasName("set") and arg = 1
  or
  // java.util.Vector
  method.(CollectionMethod).hasName(["addElement", "insertElementAt", "setElementAt"]) and arg = 0
  or
  // java.util.Stack
  method.(CollectionMethod).hasName("push") and arg = 0
  or
  // java.util.Queue
  method.(CollectionMethod).hasName("offer") and arg = 0
  or
  // java.util.Deque
  // covered by Stack: push(E)
  method.(CollectionMethod).hasName(["addFirst", "addLast", "offerFirst", "offerLast"]) and arg = 0
  or
  // java.util.concurrent.BlockingQueue
  // covered by Queue: offer(E, long, TimeUnit)
  method.(CollectionMethod).hasName("put") and arg = 0
  or
  // java.util.concurrent.TransferQueue
  method.(CollectionMethod).hasName(["transfer", "tryTransfer"]) and arg = 0
  or
  // java.util.concurrent.BlockingDeque
  // covered by Deque: offerFirst(E, long, TimeUnit), offerLast(E, long, TimeUnit)
  method.(CollectionMethod).hasName(["putFirst", "putLast"]) and arg = 0
  or
  // java.util.Dictionary
  method
      .getDeclaringType()
      .getSourceDeclaration()
      .getASourceSupertype*()
      .hasQualifiedName("java.util", "Dictionary") and
  method.hasName("put") and
  arg = 1
}

/**
 * Holds if `method` is a library method that returns tainted data if its
 * `arg`th argument is tainted.
 */
private predicate taintPreservingArgumentToMethod(Method method, int arg) {
  method.getDeclaringType().hasQualifiedName("java.util", "Collections") and
  (
    method
        .hasName([
            "checkedCollection", "checkedList", "checkedMap", "checkedNavigableMap",
            "checkedNavigableSet", "checkedSet", "checkedSortedMap", "checkedSortedSet",
            "enumeration", "list", "max", "min", "singleton", "singletonList",
            "synchronizedCollection", "synchronizedList", "synchronizedMap",
            "synchronizedNavigableMap", "synchronizedNavigableSet", "synchronizedSet",
            "synchronizedSortedMap", "synchronizedSortedSet", "unmodifiableCollection",
            "unmodifiableList", "unmodifiableMap", "unmodifiableNavigableMap",
            "unmodifiableNavigableSet", "unmodifiableSet", "unmodifiableSortedMap",
            "unmodifiableSortedSet"
          ]) and
    arg = 0
    or
    method.hasName(["nCopies", "singletonMap"]) and arg = 1
  )
  or
  method
      .getDeclaringType()
      .getSourceDeclaration()
      .hasQualifiedName("java.util", ["List", "Map", "Set"]) and
  method.hasName("copyOf") and
  arg = 0
  or
  method.getDeclaringType().getSourceDeclaration().hasQualifiedName("java.util", "Map") and
  (
    method.hasName("of") and
    arg = any(int i | i in [1 .. 10] | 2 * i - 1)
    or
    method.hasName("entry") and
    arg = 1
  )
  or
  method.getDeclaringType().hasQualifiedName("java.util", "Arrays") and
  (
    method.hasName(["copyOf", "copyOfRange", "spliterator", "stream"]) and
    arg = 0
  )
}

/**
 * Holds if `method` is a library method that returns tainted data if any
 * of its arguments are tainted.
 */
private predicate taintPreservingArgumentToMethod(Method method) {
  method.getDeclaringType().getSourceDeclaration().hasQualifiedName("java.util", ["Set", "List"]) and
  method.hasName("of")
  or
  method.getDeclaringType().getSourceDeclaration().hasQualifiedName("java.util", "Map") and
  method.hasName("ofEntries")
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
  exists(Method m, int i, MethodCall ma |
    taintPreservingArgumentToQualifier(m, i) and
    ma.getMethod() = m and
    tracked = ma.getArgument(i) and
    sink = ma.getQualifier()
  )
}

/** Access to a method that passes taint from an argument. */
private predicate argToMethodStep(Expr tracked, MethodCall sink) {
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
  or
  taintPreservingArgumentToMethod(sink.getMethod()) and
  tracked = sink.getAnArgument()
}

/**
 * Holds if `tracked` and `sink` are arguments to a method that transfers taint
 * between arguments.
 */
private predicate argToArgStep(Expr tracked, Expr sink) {
  exists(MethodCall ma, Method method, int input, int output |
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

/**
 * Holds if the step from `node1` to `node2` stores a value in an array.
 * This covers array assignments and initializers as well as implicit array
 * creations for varargs.
 */
predicate arrayStoreStep(Node node1, Node node2) {
  exists(Argument arg |
    node1.asExpr() = arg and
    arg.isVararg() and
    node2.(ImplicitVarargsArray).getCall() = arg.getCall()
  )
  or
  node2.asExpr().(ArrayInit).getAnInit() = node1.asExpr()
  or
  exists(Assignment assign | assign.getSource() = node1.asExpr() |
    node2.(PostUpdateNode).getPreUpdateNode().asExpr() = assign.getDest().(ArrayAccess).getArray()
  )
  or
  exists(Expr arr, Call call |
    arr = node2.(PostUpdateNode).getPreUpdateNode().asExpr() and
    call.getArgument(1) = node1.asExpr() and
    call.getQualifier() = arr and
    arr.getType() instanceof Array and
    call.getCallee().getName() = "set"
  )
}

private predicate enhancedForStmtStep(Node node1, Node node2, Type containerType) {
  exists(EnhancedForStmt for, Expr e, SsaExplicitUpdate v |
    for.getExpr() = e and
    node1.asExpr() = e and
    containerType = e.getType() and
    v.getDefiningExpr() = for.getVariable() and
    v.getAFirstUse() = node2.asExpr()
  )
}

/**
 * Holds if the step from `node1` to `node2` reads a value from an array.
 * This covers ordinary array reads as well as array iteration through enhanced
 * `for` statements.
 */
predicate arrayReadStep(Node node1, Node node2, Type elemType) {
  exists(ArrayAccess aa |
    aa.getArray() = node1.asExpr() and
    aa.getType() = elemType and
    node2.asExpr() = aa
  )
  or
  exists(Expr arr, Call call |
    arr = node1.asExpr() and
    call = node2.asExpr() and
    arr.getType().(Array).getComponentType() = elemType and
    call.getCallee().getName() = "get" and
    call.getQualifier() = arr
  )
  or
  exists(Array arr |
    enhancedForStmtStep(node1, node2, arr) and
    arr.getComponentType() = elemType
  )
}

/**
 * Holds if the step from `node1` to `node2` reads a value from a collection.
 * This only covers iteration through enhanced `for` statements.
 */
predicate collectionReadStep(Node node1, Node node2) {
  enhancedForStmtStep(node1, node2, any(Type t | not t instanceof Array))
}
