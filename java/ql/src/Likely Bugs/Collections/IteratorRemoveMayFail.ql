/**
 * @name Call to Iterator.remove may fail
 * @description Attempting to invoke 'Iterator.remove' on an iterator over a collection that does not
 *              support element removal causes a runtime exception.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/iterator-remove-failure
 * @tags reliability
 *       correctness
 *       logic
 */

import java

class SpecialCollectionCreation extends MethodAccess {
  SpecialCollectionCreation() {
    exists(Method m, RefType rt |
      m = this.(MethodAccess).getCallee() and rt = m.getDeclaringType()
    |
      rt.hasQualifiedName("java.util", "Arrays") and m.hasName("asList")
      or
      rt.hasQualifiedName("java.util", "Collections") and
      m.getName().regexpMatch("singleton.*|unmodifiable.*")
    )
  }
}

predicate containsSpecialCollection(Expr e, SpecialCollectionCreation origin) {
  e = origin
  or
  exists(Variable v |
    containsSpecialCollection(pragma[only_bind_into](v.getAnAssignedValue()), origin) and
    e = v.getAnAccess()
  )
  or
  exists(Call c, int i |
    containsSpecialCollection(c.getArgument(i), origin) and
    e = c.getCallee().getParameter(i).getAnAccess()
  )
  or
  exists(Call c, ReturnStmt r | e = c |
    r.getEnclosingCallable() = c.getCallee() and
    containsSpecialCollection(r.getResult(), origin)
  )
}

predicate iterOfSpecialCollection(Expr e, SpecialCollectionCreation origin) {
  exists(MethodAccess ma | ma = e |
    containsSpecialCollection(ma.getQualifier(), origin) and
    ma.getCallee().hasName("iterator")
  )
  or
  exists(Variable v |
    iterOfSpecialCollection(pragma[only_bind_into](v.getAnAssignedValue()), origin) and
    e = v.getAnAccess()
  )
  or
  exists(Call c, int i |
    iterOfSpecialCollection(c.getArgument(i), origin) and
    e = c.getCallee().getParameter(i).getAnAccess()
  )
  or
  exists(Call c, ReturnStmt r | e = c |
    r.getEnclosingCallable() = c.getCallee() and
    iterOfSpecialCollection(r.getResult(), origin)
  )
}

from MethodAccess remove, SpecialCollectionCreation scc
where
  remove.getCallee().hasName("remove") and
  iterOfSpecialCollection(remove.getQualifier(), scc)
select remove,
  "This call may fail when iterating over the collection created $@, since it does not support element removal.",
  scc, "here"
