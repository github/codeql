/** Provides classes for collections. */

import csharp
import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.collections.Generic

private string modifyMethodName() {
  result =
    [
      "Add", "AddFirst", "AddLast", "Clear", "Enqueue", "ExceptWith", "Insert", "IntersectWith",
      "Push", "Remove", "RemoveAt", "RemoveFirst", "RemoveLast", "Set", "SetAll",
      "SymmetricExceptWith", "UnionWith"
    ]
}

/** A method call that modifies a collection. */
class ModifierMethodCall extends MethodCall {
  ModifierMethodCall() {
    this.getParent() instanceof ExprStmt and
    this.getTarget().hasName(modifyMethodName())
  }
}

/** An access that modifies a collection. */
class CollectionModificationAccess extends Access {
  CollectionModificationAccess() {
    this = any(ModifierMethodCall mc).getQualifier() or
    this = any(ElementWrite ew).getQualifier()
  }
}

private string collectionTypeName() {
  result =
    [
      "ArrayList", "BitArray", "Hashtable", "ICollection", "IDictionary", "IList", "Queue",
      "ReadOnlyCollectionBase", "SortedList", "Stack"
    ]
}

private string collectionNamespaceName() { result = ["Mono.Collections", "System.Collections"] }

private string genericCollectionNamespaceName() {
  result = ["Mono.Collections.Generic", "System.Collections.Generic"]
}

private string genericCollectionTypeName() {
  result =
    [
      "Dictionary`2", "HashSet`1", "ICollection`1", "IDictionary`2", "IList`1", "ISet`1",
      "LinkedList`1", "List`1", "Queue`1", "SortedDictionary`2", "SortedList`2", "SortedSet`1",
      "Stack`1", "SynchronizedCollection`1", "SynchronizedKeyedCollection`1",
      "SynchronizedReadOnlyCollection`1"
    ]
}

/** A collection type. */
class CollectionType extends RefType {
  CollectionType() {
    exists(RefType base | base = this.getABaseType*() |
      base.hasFullyQualifiedName(collectionNamespaceName(), collectionTypeName())
      or
      base.(ConstructedType)
          .getUnboundGeneric()
          .hasFullyQualifiedName(genericCollectionNamespaceName(), genericCollectionTypeName())
    )
    or
    this instanceof ArrayType
  }
}

/**
 * A collection type that can be used as a `params` parameter type.
 */
abstract private class ParamsCollectionTypeImpl extends ValueOrRefType {
  /**
   * Gets the element type of this collection, for example `int` in `IEnumerable<int>`.
   */
  abstract Type getElementType();
}

private class ParamsArrayType extends ParamsCollectionTypeImpl instanceof ArrayType {
  override Type getElementType() { result = ArrayType.super.getElementType() }
}

private class ParamsConstructedCollectionTypes extends ParamsCollectionTypeImpl {
  private ConstructedType base;

  ParamsConstructedCollectionTypes() {
    exists(UnboundGenericType unboundbase |
      base = this.getABaseType*() and unboundbase = base.getUnboundGeneric()
    |
      unboundbase instanceof SystemCollectionsGenericIEnumerableTInterface or
      unboundbase instanceof SystemCollectionsGenericICollectionInterface or
      unboundbase instanceof SystemCollectionsGenericIListTInterface or
      unboundbase instanceof SystemCollectionsGenericIReadOnlyCollectionTInterface or
      unboundbase instanceof SystemCollectionsGenericIReadOnlyListTInterface or
      unboundbase instanceof SystemSpanStruct or
      unboundbase instanceof SystemReadOnlySpanStruct
    )
  }

  override Type getElementType() { result = base.getTypeArgument(0) }
}

final class ParamsCollectionType = ParamsCollectionTypeImpl;

/** Holds if `t` is a collection type. */
predicate isCollectionType(ValueOrRefType t) {
  t.getABaseType*() instanceof SystemCollectionsIEnumerableInterface and
  not t instanceof StringType
}

/** An object creation that creates an empty collection. */
class EmptyCollectionCreation extends ObjectCreation {
  EmptyCollectionCreation() {
    this.getType() instanceof CollectionType and
    not this.hasInitializer() and
    this.getNumberOfArguments() = 0
  }
}

private string readonlyMethodName() {
  result =
    [
      "BinarySearch", "Clone", "Contains", "ContainsKey", "ContainsValue", "CopyTo", "Equals",
      "FixedArray", "FixedSize", "Get", "GetEnumerator", "GetHashCode", "GetRange", "IndexOf",
      "IsProperSubsetOf", "IsProperSupersetOf", "IsSubsetOf", "IsSupersetOf", "LastIndexOf",
      "MemberwiseClone", "Peek", "ToArray", "ToString", "TryGetValue"
    ]
}

private string noAddMethodName() {
  result = readonlyMethodName() or
  result = ["Dequeue", "Pop"]
}

/** Holds if `a` is an access that does not modify a collection. */
private predicate readonlyAccess(Access a) {
  // A read-only method call
  exists(MethodCall mc | mc.getQualifier() = a | mc.getTarget().hasName(readonlyMethodName()))
  or
  // Any property read
  a = any(PropertyRead pr).getQualifier()
  or
  // An element read
  a = any(ElementRead er).getQualifier()
}

/** An access that does not add items to a collection. */
class NoAddAccess extends Access {
  NoAddAccess() {
    readonlyAccess(this)
    or
    exists(MethodCall mc | mc.getQualifier() = this | mc.getTarget().hasName(noAddMethodName()))
  }
}

/** An access that initializes an empty collection. */
class EmptyInitializationAccess extends Access {
  EmptyInitializationAccess() {
    exists(AssignableDefinition def | def.getTargetAccess() = this |
      def.getSource() instanceof EmptyCollectionCreation
    )
  }
}
