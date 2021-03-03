/**
 * @name Sensitive cookies without the HttpOnly response header set
 * @description Sensitive cookies without 'HttpOnly' leaves session cookies vulnerable to an XSS attack.
 * @kind path-problem
 * @id java/sensitive-cookie-not-httponly
 * @tags security
 *       external/cwe/cwe-1004
 */

import java
import semmle.code.java.frameworks.Servlets
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/** Gets a regular expression for matching common names of sensitive cookies. */
string getSensitiveCookieNameRegex() { result = "(?i).*(auth|session|token|key|credential).*" }

/** Holds if a string is concatenated with the name of a sensitive cookie. */
predicate isSensitiveCookieNameExpr(Expr expr) {
  expr.(CompileTimeConstantExpr)
      .getStringValue()
      .toLowerCase()
      .regexpMatch(getSensitiveCookieNameRegex()) or
  isSensitiveCookieNameExpr(expr.(AddExpr).getAnOperand())
}

/** Holds if a string is concatenated with the `HttpOnly` flag. */
predicate hasHttpOnlyExpr(Expr expr) {
  expr.(CompileTimeConstantExpr).getStringValue().toLowerCase().matches("%httponly%") or
  hasHttpOnlyExpr(expr.(AddExpr).getAnOperand())
}

/** The method call `Set-Cookie` of `addHeader` or `setHeader`. */
class SetCookieMethodAccess extends MethodAccess {
  SetCookieMethodAccess() {
    (
      this.getMethod() instanceof ResponseAddHeaderMethod or
      this.getMethod() instanceof ResponseSetHeaderMethod
    ) and
    this.getArgument(0).(CompileTimeConstantExpr).getStringValue().toLowerCase() = "set-cookie"
  }
}

/** Sensitive cookie name used in a `Cookie` constructor or a `Set-Cookie` call. */
class SensitiveCookieNameExpr extends Expr {
  SensitiveCookieNameExpr() {
    exists(
      ClassInstanceExpr cie, Expr e // new Cookie("jwt_token", token)
    |
      (
        cie.getConstructor().getDeclaringType().hasQualifiedName("javax.servlet.http", "Cookie") or
        cie.getConstructor()
            .getDeclaringType()
            .getASupertype*()
            .hasQualifiedName(["javax.ws.rs.core", "jakarta.ws.rs.core"], "Cookie")
      ) and
      this = cie and
      isSensitiveCookieNameExpr(e) and
      DataFlow::localExprFlow(e, cie.getArgument(0))
    )
    or
    exists(
      SetCookieMethodAccess ma, Expr e // response.addHeader("Set-Cookie: token=" +authId + ";HttpOnly;Secure")
    |
      this = ma.getArgument(1) and
      isSensitiveCookieNameExpr(e) and
      DataFlow::localExprFlow(e, ma.getArgument(1))
    )
  }
}

/** Sink of adding a cookie to the HTTP response. */
class CookieResponseSink extends DataFlow::ExprNode {
  CookieResponseSink() {
    exists(MethodAccess ma |
      (
        ma.getMethod() instanceof ResponseAddCookieMethod and
        this.getExpr() = ma.getArgument(0)
        or
        ma instanceof SetCookieMethodAccess and
        this.getExpr() = ma.getArgument(1)
      )
    )
  }
}

/**
 * Holds if `node` is an access to a variable which has `setHttpOnly(true)` called on it and is also
 * the first argument to a call to the method `addCookie` of `javax.servlet.http.HttpServletResponse`.
 */
predicate setHttpOnlyMethodAccess(DataFlow::Node node) {
  exists(
    MethodAccess addCookie, Variable cookie, MethodAccess m // jwtCookie.setHttpOnly(true)
  |
    addCookie.getMethod() instanceof ResponseAddCookieMethod and
    addCookie.getArgument(0) = cookie.getAnAccess() and
    m.getMethod().getName() = "setHttpOnly" and
    m.getArgument(0).(BooleanLiteral).getBooleanValue() = true and
    m.getQualifier() = cookie.getAnAccess() and
    node.asExpr() = cookie.getAnAccess()
  )
}

/**
 * Holds if `node` is a string that contains `httponly` and which flows to the second argument
 * of a method to set a cookie.
 */
predicate setHttpOnlyInSetCookie(DataFlow::Node node) {
  exists(SetCookieMethodAccess sa |
    hasHttpOnlyExpr(node.asExpr()) and
    DataFlow::localExprFlow(node.asExpr(), sa.getArgument(1))
  )
}

/** Holds if `cie` is an invocation of a JAX-RS `NewCookie` constructor that sets `HttpOnly` to true. */
predicate setHttpOnlyInNewCookie(ClassInstanceExpr cie) {
  cie.getConstructedType().hasQualifiedName(["javax.ws.rs.core", "jakarta.ws.rs.core"], "NewCookie") and
  (
    cie.getNumArgument() = 6 and cie.getArgument(5).(BooleanLiteral).getBooleanValue() = true // NewCookie(Cookie cookie, String comment, int maxAge, Date expiry, boolean secure, boolean httpOnly)
    or
    cie.getNumArgument() = 8 and
    cie.getArgument(6).getType() instanceof BooleanType and
    cie.getArgument(7).(BooleanLiteral).getBooleanValue() = true // NewCookie(String name, String value, String path, String domain, String comment, int maxAge, boolean secure, boolean httpOnly)
    or
    cie.getNumArgument() = 10 and cie.getArgument(9).(BooleanLiteral).getBooleanValue() = true // NewCookie(String name, String value, String path, String domain, int version, String comment, int maxAge, Date expiry, boolean secure, boolean httpOnly)
  )
}

/**
 * Holds if the node is a test method indicated by:
 *    a) in a test directory such as `src/test/java`
 *    b) in a test package whose name has the word `test`
 *    c) in a test class whose name has the word `test`
 *    d) in a test class implementing a test framework such as JUnit or TestNG
 */
predicate isTestMethod(DataFlow::Node node) {
  exists(MethodAccess ma, Method m |
    node.asExpr() = ma.getAnArgument() and
    m = ma.getEnclosingCallable() and
    (
      m.getDeclaringType().getName().toLowerCase().matches("%test%") or // Simple check to exclude test classes to reduce FPs
      m.getDeclaringType().getPackage().getName().toLowerCase().matches("%test%") or // Simple check to exclude classes in test packages to reduce FPs
      exists(m.getLocation().getFile().getAbsolutePath().indexOf("/src/test/java")) or //  Match test directory structure of build tools like maven
      m instanceof TestMethod // Test method of a test case implementing a test framework such as JUnit or TestNG
    )
  )
}

/**
 * A taint configuration tracking flow from a sensitive cookie without the `HttpOnly` flag
 * set to its HTTP response.
 */
class MissingHttpOnlyConfiguration extends TaintTracking::Configuration {
  MissingHttpOnlyConfiguration() { this = "MissingHttpOnlyConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof SensitiveCookieNameExpr
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CookieResponseSink }

  override predicate isSanitizer(DataFlow::Node node) {
    // cookie.setHttpOnly(true)
    setHttpOnlyMethodAccess(node)
    or
    // response.addHeader("Set-Cookie", "token=" +authId + ";HttpOnly;Secure")
    setHttpOnlyInSetCookie(node)
    or
    // new NewCookie("session-access-key", accessKey, "/", null, null, 0, true, true)
    setHttpOnlyInNewCookie(node.asExpr())
    or
    // Test class or method
    isTestMethod(node)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(
      MethodAccess ma // `toString` call on a cookie object
    |
      ma.getQualifier() = pred.asExpr() and
      ma.getMethod().hasName("toString") and
      ma = succ.asExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, MissingHttpOnlyConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ doesn't have the HttpOnly flag set.", source.getNode(),
  "This sensitive cookie"
