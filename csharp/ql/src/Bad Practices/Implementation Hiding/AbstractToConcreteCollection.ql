/**
 * @name Cast from abstract to concrete collection
 * @description Finds casts from an abstract collection to a concrete implementation
 *              type. This makes the code brittle; it is best to program against the
 *              abstract collection interfaces only.
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

/** A sub-interface of Collection */
class CollectionInterface extends Interface {
  CollectionInterface() {
    exists(string name |
           this.getSourceDeclaration().getABaseType*().getName() = name and
           (   name.matches("ICollection<%>")
            or name="ICollection")
    )
  }
}

from CastExpr e, Class c, CollectionInterface i
where e.getType() = c and
      e.getExpr().getType().(RefType).getSourceDeclaration() = i
select e, "Questionable cast from abstract " + i.getName()
            + " to concrete implementation " + c.getName() + "."
