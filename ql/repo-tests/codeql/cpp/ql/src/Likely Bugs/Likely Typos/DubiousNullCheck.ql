/**
 * @name Dubious NULL check
 * @description The address of a field (except the first) will never be NULL,
 *              so it is misleading, at best, to check for that case.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cpp/dubious-null-check
 * @tags reliability
 *       readability
 */

import cpp

predicate zeroComparison(EqualityOperation e) {
  exists(Expr zero | zero.getValue() = "0" |
    zero = e.getLeftOperand() or
    zero = e.getRightOperand()
  )
}

predicate inNullContext(AddressOfExpr e) {
  e.getFullyConverted().getUnderlyingType() instanceof BoolType
  or
  exists(ControlStructure c | c.getControllingExpr() = e)
  or
  exists(EqualityOperation cmp | zeroComparison(cmp) |
    e = cmp.getLeftOperand() or
    e = cmp.getRightOperand()
  )
}

FieldAccess chainedFields(FieldAccess fa) {
  result = fa or
  result = chainedFields(fa.getQualifier())
}

from AddressOfExpr addrof, FieldAccess fa, Variable v, int offset
where
  fa = addrof.getOperand() and
  inNullContext(addrof) and
  not addrof.isInMacroExpansion() and
  v.getAnAccess() = chainedFields(fa).getQualifier() and
  not v instanceof MemberVariable and
  offset = strictsum(chainedFields(fa).getTarget().getByteOffset()) and
  offset != 0
select addrof, "This will only be NULL if " + v.getName() + " == -" + offset + "."
