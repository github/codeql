/**
 * @name Container size compared to zero.
 * @description Comparing the size of a container to zero with this operator will always return the same value.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cs/test-for-negative-container-size
 * @tags reliability
 *       correctness
 *       logic
 */

import csharp
import semmle.code.csharp.commons.Assertions

private predicate propertyOverrides(Property p, string baseClass, string property) {
  exists(Property p2 |
    p2.getSourceDeclaration().getDeclaringType().hasQualifiedName(baseClass) and
    p2.hasName(property)
  |
    p.overridesOrImplementsOrEquals(p2)
  )
}

private predicate containerSizeAccess(PropertyAccess pa, string containerKind) {
  (
    propertyOverrides(pa.getTarget(), "System.Collections.Generic.ICollection<>", "Count") or
    propertyOverrides(pa.getTarget(), "System.Collections.Generic.IReadOnlyCollection<>", "Count") or
    propertyOverrides(pa.getTarget(), "System.Collections.ICollection", "Count")
  ) and
  containerKind = "a collection"
  or
  (
    propertyOverrides(pa.getTarget(), "System.String", "Length") and containerKind = "a string"
    or
    propertyOverrides(pa.getTarget(), "System.Array", "Length") and containerKind = "an array"
  )
}

class ZeroLiteral extends Expr {
  ZeroLiteral() { getValue() = "0" }
}

/**
 * Whether `smaller` is checked to be no greater than `greater` by `e` being `trueOrFalse`
 */
private predicate checkedLT(BinaryOperation e, Expr greater, Expr smaller, string trueOrFalse) {
  greater = e.(GEExpr).getLeftOperand() and
  smaller = e.(GEExpr).getRightOperand() and
  trueOrFalse = "true"
  or
  greater = e.(LEExpr).getRightOperand() and
  smaller = e.(LEExpr).getLeftOperand() and
  trueOrFalse = "true"
  or
  greater = e.(GTExpr).getRightOperand() and
  smaller = e.(GTExpr).getLeftOperand() and
  trueOrFalse = "false"
  or
  greater = e.(LTExpr).getLeftOperand() and
  smaller = e.(LTExpr).getRightOperand() and
  trueOrFalse = "false"
}

private predicate comparisonOfContainerSizeToZero(
  BinaryOperation e, string containerKind, string trueOrFalse
) {
  exists(Expr sizeAccess |
    containerSizeAccess(sizeAccess, containerKind) and
    checkedLT(e, sizeAccess, any(ZeroLiteral zl), trueOrFalse)
  )
}

from BinaryOperation e, string containerKind, string trueOrFalse
where
  comparisonOfContainerSizeToZero(e, containerKind, trueOrFalse) and
  not isExprInAssertion(e)
select e,
  "This expression is always " + trueOrFalse + ", since " + containerKind +
    " can never have negative size."
