import csharp

string modifyMethodName()
{
  result="Add"  or
  result="AddFirst" or
  result="AddLast" or
  result="Clear" or
  result="Enqueue" or
  result="ExceptWith" or
  result="Insert" or
  result="IntersectWith" or
  result="Push" or
  result="Remove" or
  result="RemoveAt" or
  result="RemoveFirst" or
  result="RemoveLast" or
  result="Set" or
  result="SetAll" or
  result="SymmetricExceptWith" or
  result="UnionWith"
}

class ModifierMethodCall extends MethodCall
{
  ModifierMethodCall()
  {
    getParent() instanceof ExprStmt and
    this.getTarget().hasName(modifyMethodName())
  }
}

string collectionTypeName()
{
  result="ArrayList" or
  result="BitArray" or
  result="Hashtable" or
  result="ICollection" or
  result="IDictionary" or
  result="IList" or
  result="Queue" or
  result="ReadOnlyCollectionBase" or
  result="SortedList" or
  result="Stack"
}

string collectionNamespaceName()
{
  result="Mono.Collections" or
  result="System.Collections"
}

string genericCollectionNamespaceName()
{
  result="Mono.Collections.Generic" or
  result="System.Collections.Generic"
}

string genericCollectionTypeName()
{
  result="Dictionary<,>" or
  result="HashSet<>" or
  result="ICollection<>" or
  result="IDictionary<,>" or
  result="IList<>" or
  result="ISet<>" or
  result="LinkedList<>" or
  result="List<>" or
  result="Queue<>" or
  result="SortedDictionary<,>" or
  result="SortedList<,>" or
  result="SortedSet<>" or
  result="Stack<>" or
  result="SynchronizedCollection<>" or
  result="SynchronizedKeyedCollection<>" or
  result="SynchronizedReadOnlyCollection<>"
}

predicate isCollectionType(RefType r)
{
  r.hasQualifiedName( collectionNamespaceName(), collectionTypeName() ) or
  r.(ConstructedType).getUnboundGeneric().hasQualifiedName( genericCollectionNamespaceName(), genericCollectionTypeName() )
}

class EmptyCollectionCreation extends ObjectCreation
{
  EmptyCollectionCreation()
  {
    isCollectionType(getType())
    and not hasInitializer()
    and getNumberOfArguments()=0
  }
}

// Methods that do not mutate a collection.
// These methods are useless on empty collections.
string readonlyMethodName()
{
  result="BinarySearch" or
  result="Clone" or
  result="Contains" or
  result="ContainsKey" or
  result="ContainsValue" or
  result="CopyTo" or
  result="Equals" or
  result="FixedArray" or
  result="FixedSize" or
  result="Get" or
  result="GetEnumerator" or
  result="GetHashCode" or
  result="GetRange" or
  result="IndexOf" or
  result="IsProperSubsetOf" or
  result="IsProperSupersetOf" or
  result="IsSubsetOf" or
  result="IsSupersetOf" or
  result="LastIndexOf" or
  result="MemberwiseClone" or
  result="Peek" or
  result="ToArray" or
  result="ToString" or
  result="TryGetValue"
}

// Methods that do not modify an empty collection.
// These methods are useless on empty collections.
string noAddMethodName()
{
  result = readonlyMethodName() or
  result="Dequeue" or
  result="Pop"
}

// An access that does not modify the collection
predicate readonlyAccess(Access a)
{
  // A read-only method call
  exists( MethodCall mc | mc.getQualifier()=a | mc.getTarget().hasName(readonlyMethodName()) )

  // Any property access
  or exists( PropertyAccess pa | pa.getQualifier()=a )

  // An indexed read
  or exists( IndexerAccess ia | ia.getQualifier()=a | not ia.getParent().(Assignment).getLValue()=ia )
}

// An access that does not add items to a collection
predicate noAddAccess(Access a)
{
  readonlyAccess(a)
  or exists( MethodCall mc | mc.getQualifier()=a | mc.getTarget().hasName(noAddMethodName()) )
}

// An empty collection is assigned
predicate emptyCollectionAssignment(Access a)
{
  exists( Assignment ass | ass.getLValue()=a | ass.getRValue() instanceof EmptyCollectionCreation )
  or a.(LocalVariableDeclAndInitExpr).getRValue() instanceof EmptyCollectionCreation
}
