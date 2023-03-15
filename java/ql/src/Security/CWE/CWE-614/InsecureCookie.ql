/**
 * @name Failure to use secure cookies
 * @description Insecure cookies may be sent in cleartext, which makes them vulnerable to
 *              interception.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision high
 * @id java/insecure-cookie
 * @tags security
 *       external/cwe/cwe-614
 */

import java
import semmle.code.java.frameworks.Servlets
import semmle.code.java.dataflow.DataFlow

predicate isSafeSecureCookieSetting(Expr e) {
  e.(CompileTimeConstantExpr).getBooleanValue() = true
  or
  exists(Method isSecure |
    isSecure.getName() = "isSecure" and
    isSecure.getDeclaringType().getASourceSupertype*() instanceof ServletRequest
  |
    e.(MethodAccess).getMethod() = isSecure
  )
}

private module SecureCookieConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(MethodAccess ma, Method m | ma.getMethod() = m |
      m.getDeclaringType() instanceof TypeCookie and
      m.getName() = "setSecure" and
      source.asExpr() = ma.getQualifier() and
      forex(DataFlow::Node argSource |
        DataFlow::localFlow(argSource, DataFlow::exprNode(ma.getArgument(0))) and
        not DataFlow::localFlowStep(_, argSource)
      |
        isSafeSecureCookieSetting(argSource.asExpr())
      )
    )
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() =
      any(MethodAccess add | add.getMethod() instanceof ResponseAddCookieMethod).getArgument(0)
  }
}

module SecureCookieFlow = DataFlow::Make<SecureCookieConfiguration>;

from MethodAccess add
where
  add.getMethod() instanceof ResponseAddCookieMethod and
  not SecureCookieFlow::hasFlowToExpr(add.getArgument(0))
select add, "Cookie is added to response without the 'secure' flag being set."
