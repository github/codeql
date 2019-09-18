/**
 * @name Cast from abstract to concrete collection
 * @description A cast from an abstract collection to a concrete implementation type
 *              makes the code brittle; it is best to program against the abstract
 *              collection interface only.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/cast-from-abstract-to-concrete-collection
 * @tags reliability
 *       maintainability
 *       modularity
 *       external/cwe/cwe-485
 */

import csharp
import semmle.code.csharp.frameworks.system.Collections
import semmle.code.csharp.frameworks.system.collections.Generic

/** A collection interface. */
class CollectionInterface extends Interface {
  CollectionInterface() {
    exists(Interface i | i = this.getABaseInterface*() |
      i instanceof SystemCollectionsICollectionInterface or
      i.getSourceDeclaration() instanceof SystemCollectionsGenericICollectionInterface or
      i instanceof SystemCollectionsIEnumerableInterface or
      i.getSourceDeclaration() instanceof SystemCollectionsGenericIEnumerableTInterface
    )
  }
}

from CastExpr e, Class c, CollectionInterface i
where
  e.getType() = c and
  e.getExpr().getType() = i and
  c.isImplicitlyConvertibleTo(i)
select e,
  "Questionable cast from abstract '" + i.getName() + "' to concrete implementation '" + c.getName()
    + "'."
