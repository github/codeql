/**
 * Models a very basic guard for the tainted path queries.
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.security.PathCreation
import semmle.code.java.frameworks.Networking
import semmle.code.java.dataflow.TaintTracking

abstract class TaintedPathCommonConfig extends TaintTracking::Configuration {
  bindingset[this]
  TaintedPathCommonConfig() { any() }

  final override predicate isAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(Argument a |
      a = n1.asExpr() and
      a.getCall() = n2.asExpr() and
      a = any(TaintPreservingUriCtorParam tpp).getAnArgument()
    )
  }
}

private class TaintPreservingUriCtorParam extends Parameter {
  TaintPreservingUriCtorParam() {
    exists(Constructor ctor, int idx, int nParams |
      ctor.getDeclaringType() instanceof TypeUri and
      this = ctor.getParameter(idx) and
      nParams = ctor.getNumberOfParameters()
    |
      // URI(String scheme, String ssp, String fragment)
      idx = 1 and nParams = 3
      or
      // URI(String scheme, String host, String path, String fragment)
      idx = [1, 2] and nParams = 4
      or
      // URI(String scheme, String authority, String path, String query, String fragment)
      idx = 2 and nParams = 5
      or
      // URI(String scheme, String userInfo, String host, int port, String path, String query, String fragment)
      idx = 4 and nParams = 7
    )
  }
}

private predicate inWeakCheck(Expr e) {
  // None of these are sufficient to guarantee that a string is safe.
  exists(MethodAccess m, Method def | m.getQualifier() = e and m.getMethod() = def |
    def.getName() = "startsWith" or
    def.getName() = "endsWith" or
    def.getName() = "isEmpty" or
    def.getName() = "equals"
  )
  or
  // Checking against `null` has no bearing on path traversal.
  exists(EqualityTest b | b.getAnOperand() = e | b.getAnOperand() instanceof NullLiteral)
}

// Ignore cases where the variable has been checked somehow,
// but allow some particularly obviously bad cases.
predicate guarded(VarAccess e) {
  exists(PathCreation p | e = p.getAnInput()) and
  exists(ConditionBlock cb, Expr c |
    cb.getCondition().getAChildExpr*() = c and
    c = e.getVariable().getAnAccess() and
    cb.controls(e.getBasicBlock(), true) and
    // Disallow a few obviously bad checks.
    not inWeakCheck(c)
  )
}
