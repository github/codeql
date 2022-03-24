/** Provides classes for collections. */

import csharp
import semmle.code.csharp.frameworks.system.Collections

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
      "Dictionary<,>", "HashSet<>", "ICollection<>", "IDictionary<,>", "IList<>", "ISet<>",
      "LinkedList<>", "List<>", "Queue<>", "SortedDictionary<,>", "SortedList<,>", "SortedSet<>",
      "Stack<>", "SynchronizedCollection<>", "SynchronizedKeyedCollection<>",
      "SynchronizedReadOnlyCollection<>"
    ]
}

/** A collection type. */
class CollectionType extends RefType {
  CollectionType() {
    exists(RefType base | base = this.getABaseType*() |
      base.hasQualifiedName(collectionNamespaceName(), collectionTypeName())
      or
      base.(ConstructedType)
          .getUnboundGeneric()
          .hasQualifiedName(genericCollectionNamespaceName(), genericCollectionTypeName())
    )
    or
    this instanceof ArrayType
  }
}

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
