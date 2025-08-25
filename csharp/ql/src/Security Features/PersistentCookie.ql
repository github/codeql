/**
 * @name Cookie security: persistent cookie
 * @description Persistent cookies are vulnerable to attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.2
 * @precision high
 * @id cs/web/persistent-cookie
 * @tags security
 *       external/cwe/cwe-539
 */

import csharp

class FutureDateExpr extends MethodCall {
  FutureDateExpr() {
    exists(PropertyAccess pa |
      pa = this.getQualifier() and
      pa.getTarget().hasName("Now") and
      pa.getTarget().getDeclaringType().hasFullyQualifiedName("System", "DateTime")
    ) and
    this.getTarget().getName().matches("Add%")
  }

  float getTimeInSecond() {
    this.getTarget().hasName("AddTicks") and
    result = this.getArgument(0).getValue().toFloat() / 10000000
    or
    this.getTarget().hasName("AddMilliseconds") and
    result = this.getArgument(0).getValue().toFloat() / 1000
    or
    this.getTarget().hasName("AddSeconds") and result = this.getArgument(0).getValue().toFloat()
    or
    this.getTarget().hasName("AddMinutes") and
    result = this.getArgument(0).getValue().toFloat() * 60
    or
    this.getTarget().hasName("AddHours") and
    result = this.getArgument(0).getValue().toFloat() * 60 * 60
    or
    this.getTarget().hasName("AddDays") and
    result = this.getArgument(0).getValue().toFloat() * 60 * 60 * 24
    or
    this.getTarget().hasName("AddMonths") and
    result = this.getArgument(0).getValue().toFloat() * 60 * 60 * 24 * 365.25 / 12
  }

  predicate timeIsNotClear() {
    this.getTarget().hasName("Add") or
    not exists(this.getArgument(0).getValue())
  }
}

from Assignment a, PropertyAccess pa, FutureDateExpr fde
where
  a.getLValue() = pa and
  a.getRValue() = fde and
  pa.getTarget().hasName("Expires") and
  pa.getTarget().getDeclaringType().hasFullyQualifiedName("System.Web", "HttpCookie") and
  (fde.timeIsNotClear() or fde.getTimeInSecond() > 300) // 5 minutes max
select a, "Avoid persistent cookies."
