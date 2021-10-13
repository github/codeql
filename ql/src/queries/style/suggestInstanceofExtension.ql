/**
 * @name Suggest using non-extending subtype relationships.
 * @description Non-extending subtypes ("instanceof extensions") are generally preferrable to instanceof expressions in characteristic predicates.
 * @kind problem
 * @problem.severity warning
 * @id ql/suggest-instanceof-extension
 * @tags maintainability
 * @precision medium
 */

import ql

InstanceOf instanceofInCharPred(Class c) {
  result = c.getCharPred().getBody()
  or
  exists(Conjunction conj |
    conj = c.getCharPred().getBody() and
    result = conj.getAnOperand()
  )
}

predicate instanceofThisInCharPred(Class c, TypeExpr type) {
  exists(InstanceOf instanceOf |
    instanceOf = instanceofInCharPred(c) and
    instanceOf.getExpr() instanceof ThisAccess and
    type = instanceOf.getType()
  )
}

predicate classWithInstanceofThis(Class c, TypeExpr type) {
  instanceofThisInCharPred(c, type) and
  exists(ClassPredicate classPred |
    classPred = c.getAClassPredicate() and
    exists(MemberCall call, InlineCast cast |
      call.getEnclosingPredicate() = classPred and
      cast = call.getBase() and
      cast.getBase() instanceof ThisAccess and
      cast.getTypeExpr().getResolvedType() = type.getResolvedType()
    )
  )
}

from Class c, TypeExpr type, string message
where
  classWithInstanceofThis(c, type) and
  message = "consider defining $@ as non-extending subtype of $@"
select c, message, c, c.getName(), type, type.getResolvedType().getName()
