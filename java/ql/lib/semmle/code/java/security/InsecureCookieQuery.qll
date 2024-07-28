/** Provides a dataflow configuration to reason about the failure to use secure cookies. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.frameworks.Servlets

private predicate isSafeSecureCookieSetting(Expr e) {
  e.(CompileTimeConstantExpr).getBooleanValue() = true
  or
  exists(Method isSecure |
    isSecure.hasName("isSecure") and
    isSecure.getDeclaringType().getASourceSupertype*() instanceof ServletRequest
  |
    e.(MethodCall).getMethod() = isSecure
  )
}

/** A dataflow configuration to reason about the failure to use secure cookies. */
module SecureCookieConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(MethodCall ma, Method m | ma.getMethod() = m |
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
      any(MethodCall add | add.getMethod() instanceof ResponseAddCookieMethod).getArgument(0)
  }
}

/** Data flow to reason about the failure to use secure cookies. */
module SecureCookieFlow = DataFlow::Global<SecureCookieConfig>;
