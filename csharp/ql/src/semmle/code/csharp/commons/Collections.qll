/** Provides classes for collections. */

import csharp

private string modifyMethodName() {
  result = "Add" or
  result = "AddFirst" or
  result = "AddLast" or
  result = "Clear" or
  result = "Enqueue" or
  result = "ExceptWith" or
  result = "Insert" or
  result = "IntersectWith" or
  result = "Push" or
  result = "Remove" or
  result = "RemoveAt" or
  result = "RemoveFirst" or
  result = "RemoveLast" or
  result = "Set" or
  result = "SetAll" or
  result = "SymmetricExceptWith" or
  result = "UnionWith"
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
  result = "ArrayList" or
  result = "BitArray" or
  result = "Hashtable" or
  result = "ICollection" or
  result = "IDictionary" or
  result = "IList" or
  result = "Queue" or
  result = "ReadOnlyCollectionBase" or
  result = "SortedList" or
  result = "Stack"
}

private string collectionNamespaceName() {
  result = "Mono.Collections" or
  result = "System.Collections"
}

private string genericCollectionNamespaceName() {
  result = "Mono.Collections.Generic" or
  result = "System.Collections.Generic"
}

private string genericCollectionTypeName() {
  result = "Dictionary<,>" or
  result = "HashSet<>" or
  result = "ICollection<>" or
  result = "IDictionary<,>" or
  result = "IList<>" or
  result = "ISet<>" or
  result = "LinkedList<>" or
  result = "List<>" or
  result = "Queue<>" or
  result = "SortedDictionary<,>" or
  result = "SortedList<,>" or
  result = "SortedSet<>" or
  result = "Stack<>" or
  result = "SynchronizedCollection<>" or
  result = "SynchronizedKeyedCollection<>" or
  result = "SynchronizedReadOnlyCollection<>"
}

/** A collection type. */
class CollectionType extends RefType {
  CollectionType() {
    exists(RefType base | base = this.getABaseType*() |
      base.hasQualifiedName(collectionNamespaceName(), collectionTypeName())
      or
      base
          .(ConstructedType)
          .getUnboundGeneric()
          .hasQualifiedName(genericCollectionNamespaceName(), genericCollectionTypeName())
    )
    or
    this instanceof ArrayType
  }
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
  result = "BinarySearch" or
  result = "Clone" or
  result = "Contains" or
  result = "ContainsKey" or
  result = "ContainsValue" or
  result = "CopyTo" or
  result = "Equals" or
  result = "FixedArray" or
  result = "FixedSize" or
  result = "Get" or
  result = "GetEnumerator" or
  result = "GetHashCode" or
  result = "GetRange" or
  result = "IndexOf" or
  result = "IsProperSubsetOf" or
  result = "IsProperSupersetOf" or
  result = "IsSubsetOf" or
  result = "IsSupersetOf" or
  result = "LastIndexOf" or
  result = "MemberwiseClone" or
  result = "Peek" or
  result = "ToArray" or
  result = "ToString" or
  result = "TryGetValue"
}

private string noAddMethodName() {
  result = readonlyMethodName() or
  result = "Dequeue" or
  result = "Pop"
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
