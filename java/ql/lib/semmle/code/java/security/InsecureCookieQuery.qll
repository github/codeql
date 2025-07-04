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

  predicate observeDiffInformedIncrementalMode() {
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 21 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-614/InsecureCookie.ql@22:8:22:10)
  }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    none() // TODO: Make sure that this source location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 21 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-614/InsecureCookie.ql@22:8:22:10)
  }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    none() // TODO: Make sure that this sink location matches the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 21 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-614/InsecureCookie.ql@22:8:22:10)
  }
}

/** Data flow to reason about the failure to use secure cookies. */
module SecureCookieFlow = DataFlow::Global<SecureCookieConfig>;
