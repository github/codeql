/**
 * @name Method result ignored
 * @description If most of the calls to a method use the return value
 *              of that method, the calls that do not check the return value may be mistakes.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/return-value-ignored
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-252
 *       statistical
 *       non-attributable
 */

import java
import Chaining

predicate checkedMethodCall(MethodCall ma) {
  relevantMethodCall(ma, _) and
  not ma instanceof ValueDiscardingExpr
}

/**
 * Checks if a method is a used for setting up / verifying mocks. These are
 * not usually "real" method calls, and so are not interesting for the purposes
 * of this query.
 */
predicate isMockingMethod(Method m) {
  isMustBeQualifierMockingMethod(m) or
  isCardinalityClauseMethod(m) or
  isStubberMethod(m) or
  isReceiverClauseMethod(m)
}

predicate isReceiverClauseMethod(Method m) {
  m.getDeclaringType().getAnAncestor().hasQualifiedName("org.jmock.syntax", "ReceiverClause") and
  m.hasName("of")
}

predicate isCardinalityClauseMethod(Method m) {
  m.getDeclaringType().getAnAncestor().hasQualifiedName("org.jmock.syntax", "CardinalityClause") and
  (
    m.hasName("allowing") or
    m.hasName("ignoring") or
    m.hasName("never") or
    m.hasName("exactly") or
    m.hasName("atLeast") or
    m.hasName("between") or
    m.hasName("atMost") or
    m.hasName("one") or
    m.hasName("oneOf")
  )
}

predicate isStubberMethod(Method m) {
  m.getDeclaringType().getAnAncestor().hasQualifiedName("org.mockito.stubbing", "Stubber") and
  (
    m.hasName("when") or
    m.hasName("doThrow") or
    m.hasName("doAnswer") or
    m.hasName("doNothing") or
    m.hasName("doReturn") or
    m.hasName("doCallRealMethod")
  )
}

/**
 * Some mocking methods must _always_ be used as a qualifier.
 */
predicate isMustBeQualifierMockingMethod(Method m) {
  m.getDeclaringType().getAnAncestor().hasQualifiedName("org.mockito", "Mockito") and
  m.hasName("verify")
}

predicate relevantMethodCall(MethodCall ma, Method m) {
  // For "return value ignored", all method calls are relevant.
  not ma.getFile().isKotlinSourceFile() and
  ma.getMethod() = m and
  not m.getReturnType().hasName("void") and
  (not isMockingMethod(m) or isMustBeQualifierMockingMethod(m)) and
  not isMockingMethod(ma.getQualifier().(MethodCall).getMethod())
}

predicate methodStats(Method m, int used, int total, int percentage) {
  used = strictcount(MethodCall ma | checkedMethodCall(ma) and m = ma.getMethod()) and
  total = strictcount(MethodCall ma | relevantMethodCall(ma, m)) and
  percentage = used * 100 / total
}

int chainedUses(Method m) {
  result =
    count(MethodCall ma, MethodCall qual |
      ma.getMethod() = m and
      ma.getQualifier() = qual and
      qual.getMethod() = m
    )
}

from MethodCall unchecked, Method m, int percent, int total
where
  relevantMethodCall(unchecked, m) and
  not checkedMethodCall(unchecked) and
  methodStats(m, _, total, percent) and
  percent >= 90 and
  not designedForChaining(m) and
  chainedUses(m) * 100 / total <= 45 // no more than 45% of calls to this method are chained
select unchecked,
  "The result of the call is ignored, but " + percent.toString() + "% of calls to " + m.getName() +
    " use the return value."
