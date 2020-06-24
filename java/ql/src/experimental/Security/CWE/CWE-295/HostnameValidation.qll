import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.Encryption

/** A method that overrides the `javax.net.ssl.HostnameVerifier.verify` method. */
class OverridenVerifyMethod extends HostnameVerifierVerify {
  OverridenVerifyMethod() { this instanceof HostnameVerifierVerify }

  /**
   * The `hostname` parameter of this method.
   */
  Parameter getHostnameParameter() { result = getParameter(0) }

  /**
   * The `session` parameter of this method.
   */
  Parameter getSessionParameter() { result = getParameter(1) }
}

/** A return statement that returns `true`. */
class TrueReturnStmt extends ReturnStmt {
  TrueReturnStmt() { getResult().(CompileTimeConstantExpr).getBooleanValue() = true }
}

/**
 * Holds if `m` always returns `true` ignoring any exceptional flow.
 */
private predicate alwaysReturnsTrue(OverridenVerifyMethod m) {
  forex(ReturnStmt rs | rs.getEnclosingCallable() = m | rs instanceof TrueReturnStmt)
}

/** A method that overrides the `javax.net.ssl.HostnameVerifier.verify` method in a dangerous way. */
abstract class DangerousVerifyMethod extends OverridenVerifyMethod {
  /** A `Stmt` that makes this `HostnameVerifier` dangerous. */
  abstract Stmt getADangerousStmt();
}

/**
 * A method that overrides the `javax.net.ssl.HostnameVerifier.verify` method and **always** returns `true`, thus
 * accepting any certificate despite a hostname mismatch.
 */
class AlwaysAcceptingVerifyMethod extends DangerousVerifyMethod {
  AlwaysAcceptingVerifyMethod() { alwaysReturnsTrue(this) }

  override Stmt getADangerousStmt() {
    exists(TrueReturnStmt r | r.getEnclosingCallable() = this | result = r)
  }
}

/** An access to any method whose name starts with `equals` and which is defined in the `String` class. */
class StringEqualsMethodAccess extends MethodAccess {
  StringEqualsMethodAccess() {
    getMethod().getName().matches("equals%") and
    getMethod().getDeclaringType() instanceof TypeString
  }

  // TODO there is probably a better name for "anEqualityPart" but I don't know any right now
  /** Returns a part of this equality check, i.e. in the case of `foo.equals(bar)` this returns `foo` and `bar`. */
  Expr getAnEqualityPart() { result = getQualifier() or result = getArgument(0) }
}

/**
 * Get the nearest enclosing if statement, if there exists one.
 * For example consider this case:
 * ````
 * if(foo) {
 *   if(bar) {
 *     stmt
 *   }
 * }
 * ````
 * This query would then return the `bar` if statement and **not** the `foo` if statement.
 */
private IfStmt getNearestEnclosingIfStmt(Stmt stmt) {
  //result = getNerestEnclosingIfStmtRecursive(stmt) and result != stmt
  exists(IfStmt ifStmt |
    result = ifStmt and
    (
      ifStmt.getElse().getAChild*() = stmt and
      /*
       * Ensure that the `IfStmt` we found does not contain another `IfStmt`.
       * If it contains one, the result can not be the nearest enclosing `IfStmt`.
       */

      not any(ifStmt.getElse().getAChild*()) instanceof IfStmt
      or
      ifStmt.getThen().getAChild*() = stmt and
      /*
       * Ensure that the `IfStmt` we found does not contain another `IfStmt`.
       * If it contains one, the result can not be the nearest enclosing `IfStmt`.
       */

      not any(ifStmt.getThen().getAChild*()) instanceof IfStmt
    )
  )
}

/** The `javax.net.ssl.SSLSession.getPeerHost` method. */
private class SSLSessionGetPeerHostMethodAccess extends MethodAccess {
  SSLSessionGetPeerHostMethodAccess() {
    getMethod().hasName("getPeerHost") and
    getMethod().getDeclaringType() instanceof SSLSession
  }
}

/**
 * A `TaintTracking::Configuration` where the `source` is a parameter.
 * This configuration considers any getter on `SSLSession` as being tainted, but ignores any calls to `SSLSession.getPeerHost`.
 */
/*
 * private class ParameterTaintTracking extends TaintTracking::Configuration {
 *  ParameterTaintTracking() { this = "ParameterTaintTracking" }
 */

/*override */ predicate isSource(DataFlow::Node source) {
  source instanceof DataFlow::ParameterNode
}

/*override */ predicate isSink(DataFlow::Node sink) { sink instanceof DataFlow::ExprNode }

/*override */ predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma |
    ma.getMethod().getName().matches("get%") and
    ma.getMethod().getDeclaringType() instanceof SSLSession and
    not ma instanceof SSLSessionGetPeerHostMethodAccess
  |
    node2.asExpr() = ma and
    ma.getQualifier() = node1.asExpr()
  )
}

class TaintedQualifierTaintStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    isAdditionalTaintStep(node1, node2)
  }
}

/*
 * override predicate isSanitizer(DataFlow::Node node) {
 *    node.asExpr() instanceof SSLSessionGetPeerHostMethodAccess
 *  }
 * }
 */

/** Holds if `e` is derived from `parameter`. This is approximated by checking whether `e` gets tainted by `parameter`. */
private predicate isDerivedFromParameter(Parameter parameter, Expr e) {
  exists(DataFlow::ExprNode sink, DataFlow::ParameterNode source |
    source = DataFlow::parameterNode(parameter) and sink = DataFlow::exprNode(e)
  |
    TaintTracking::localTaint(source, sink)
  )
}

/**
 * A (dangerous) `StringEqualsMethodAccess` where the equality does:
 * 1. not depend on a expression that is derived from the `session` parameter of the `verify` method.
 * 2. depend on a expression that is derived from the `hostname` parameter of the `verify` method.
 */
class SSLSessionParameterIgnoringStringEqualsMethodAccess extends StringEqualsMethodAccess {
  SSLSessionParameterIgnoringStringEqualsMethodAccess() {
    exists(Expr hostname, Expr other, Parameter hostnameParameter, Parameter sessionParameter |
      hostnameParameter = getEnclosingCallable().(OverridenVerifyMethod).getHostnameParameter() and
      sessionParameter = getEnclosingCallable().(OverridenVerifyMethod).getSessionParameter() and
      getAnEqualityPart() = hostname and
      getAnEqualityPart() = other and
      hostname != other
    |
      not isDerivedFromParameter(sessionParameter, other) and
      isDerivedFromParameter(hostnameParameter, hostname)
    )
  }
}

/**
 * A `verify` method that does not verify the `hostname` correctly. It is incorrect
 * because it does not validate the `hostname` against any expression that is derived from the `session` parameter of the `verify` method.
 */
class IncorrectHostnameVerifyMethod extends DangerousVerifyMethod {
  Stmt dangerousStmt;

  IncorrectHostnameVerifyMethod() {
    /* We return `true` based on an if statement that verifies the `hostname` incorrectly.*/
    exists(TrueReturnStmt r, IfStmt i |
      getBody().getAChild*() = r and i = getNearestEnclosingIfStmt(r)
    |
      i.getCondition().getAChildExpr*() instanceof
        SSLSessionParameterIgnoringStringEqualsMethodAccess and
      dangerousStmt = i
    )
    or
    /* We return the result of an `equals` call that verifies the `hostname` incorrectly.*/
    exists(ReturnStmt r | getBody().getAChild*() = r |
      not r.getResult() instanceof BooleanLiteral and
      r.getResult().getAChildExpr*() instanceof SSLSessionParameterIgnoringStringEqualsMethodAccess and
      dangerousStmt = r
    )
  }

  override Stmt getADangerousStmt() { result = dangerousStmt }
}
