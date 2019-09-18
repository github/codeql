/**
 * Provides classes for talking about "data members" of a class.
 *
 * In C#, fields are only one kind of data member -- indexers and properties
 * give rise to very similar concepts that we may want to treat uniformly.
 */

import csharp

/**
 * Library helper class unifying the various members which may hold data,
 * namely fields, properties and indexer results.
 */
class DataMember extends Member {
  DataMember() {
    this instanceof Field or
    this instanceof Property or
    this instanceof Indexer
  }

  /**
   * Gets the type of the data member. For a field, this is the type of the field.
   * For a property or indexer, it is the type returned by the `get` accessor.
   */
  Type getType() {
    result = this.(Field).getType() or
    result = this.(Property).getType() or
    result = this.(Indexer).getType()
  }
}

/**
 * A data member which is also a collection.
 */
class CollectionMember extends DataMember {
  CollectionMember() { this.getType().(ValueOrRefType).getABaseType*().hasName("ICollection") }

  /**
   * Gets an expression corresponding to a read or write of this collection member.
   */
  Expr getAReadOrWrite() { result = this.getARead() or result = this.getAWrite() }

  /**
   * Gets an expression corresponding to a read access of this collection member.
   */
  Expr getARead() {
    // A read of a field or property can be a method call...
    result = any(MethodCall call | call.getQualifier() = this.getAnAccess())
    or
    // ... or an indexer access that isn't in an assignment position
    result = any(IndexerRead ir | ir.getQualifier() = this.getAnAccess())
  }

  /**
   * Gets an expression corresponding to a write access to this collection member.
   * Typically this will change the contents of the collection.
   */
  Expr getAWrite() {
    // A write of a field or property can be a method call to certain methods...
    exists(MethodCall call | call = result |
      call.getQualifier() = this.getAnAccess() and
      call
          .getTarget()
          .getName()
          .regexpMatch("Add.*|Append|Clear.*|Delete|" +
              "(Try)?Dequeue|Enqueue|Insert.*|(Try)?Pop|Push|(Try?)Remove.*|Replace.*|SafeDelete|Set.*|")
    )
    or
    // ... or an indexer access that is in an assignment position
    result = any(IndexerWrite iw | iw.getQualifier() = this.getAnAccess())
  }
}
