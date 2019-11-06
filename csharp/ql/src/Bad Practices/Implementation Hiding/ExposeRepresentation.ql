/**
 * @name Exposing internal representation
 * @description An object that accidentally exposes its internal representation may allow the
 *              object's fields to be modified in ways that the object is not prepared to handle.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/expose-implementation
 * @tags reliability
 *       external/cwe/cwe-485
 */

import csharp
import semmle.code.csharp.commons.Collections
import DataFlow

predicate storesCollection(Callable c, Parameter p, Field f) {
  f.getDeclaringType() = c.getDeclaringType().getABaseType*().getSourceDeclaration() and
  f.getType() instanceof CollectionType and
  p = c.getAParameter() and
  f.getAnAssignedValue() = p.getAnAccess() and
  not c.(Modifiable).isStatic()
}

predicate returnsCollection(Callable c, Field f) {
  f.getDeclaringType() = c.getDeclaringType().getABaseType*().getSourceDeclaration() and
  f.getType() instanceof CollectionType and
  c.canReturn(f.getAnAccess()) and
  not c.(Modifiable).isStatic()
}

predicate mayWriteToCollection(Expr modified) {
  modified instanceof CollectionModificationAccess
  or
  exists(Expr mid | mayWriteToCollection(mid) | localExprFlow(modified, mid))
  or
  exists(MethodCall mid, Callable c | mayWriteToCollection(mid) |
    mid.getTarget() = c and
    c.canReturn(modified)
  )
}

predicate modificationAfter(Expr before, Expr after) {
  mayWriteToCollection(after) and
  localFlowStep+(exprNode(before), exprNode(after))
}

VariableAccess varPassedInto(Callable c, Parameter p) {
  exists(Call call | call.getTarget() = c | call.getArgumentForParameter(p) = result)
}

predicate exposesByReturn(Callable c, Field f, Expr why, string whyText) {
  returnsCollection(c, f) and
  exists(MethodCall ma | ma.getTarget() = c |
    mayWriteToCollection(ma) and
    why = ma and
    whyText = "after this call to " + c.getName()
  )
}

predicate exposesByStore(Callable c, Field f, Expr why, string whyText) {
  exists(VariableAccess v, Parameter p |
    storesCollection(c, p, f) and
    v = varPassedInto(c, p) and
    modificationAfter(v, why) and
    whyText = "through the variable " + v.getTarget().getName()
  )
}

from Callable c, Field f, Expr why, string whyText
where
  exposesByReturn(c, f, why, whyText) or
  exposesByStore(c, f, why, whyText)
select c,
  "'" + c.getName() + "' exposes the internal representation stored in field '" + f.getName() +
    "'. The value may be modified $@.", why.getLocation(), whyText
