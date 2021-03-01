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
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

/** Gets a regular expression for matching common names of sensitive cookies. */
string getSensitiveCookieNameRegex() { result = "(?i).*(auth|session|token|key|credential).*" }

/** Holds if a string is concatenated with the name of a sensitive cookie. */
predicate isSensitiveCookieNameExpr(Expr expr) {
  expr.(StringLiteral)
      .getRepresentedString()
      .toLowerCase()
      .regexpMatch(getSensitiveCookieNameRegex()) or
  isSensitiveCookieNameExpr(expr.(AddExpr).getAnOperand())
}

/** Holds if a string is concatenated with the `HttpOnly` flag. */
predicate hasHttpOnlyExpr(Expr expr) {
  expr.(StringLiteral).getRepresentedString().toLowerCase().matches("%httponly%") or
  hasHttpOnlyExpr(expr.(AddExpr).getAnOperand())
}

/** The method call `Set-Cookie` of `addHeader` or `setHeader`. */
class SetCookieMethodAccess extends MethodAccess {
  SetCookieMethodAccess() {
    (
      this.getMethod() instanceof ResponseAddHeaderMethod or
      this.getMethod() instanceof ResponseSetHeaderMethod
    ) and
    this.getArgument(0).(StringLiteral).getRepresentedString().toLowerCase() = "set-cookie"
  }
}

/** Sensitive cookie name used in a `Cookie` constructor or a `Set-Cookie` call. */
class SensitiveCookieNameExpr extends Expr {
  SensitiveCookieNameExpr() {
    isSensitiveCookieNameExpr(this) and
    (
      exists(
        ClassInstanceExpr cie // new Cookie("jwt_token", token)
      |
        (
          cie.getConstructor().getDeclaringType().hasQualifiedName("javax.servlet.http", "Cookie") or
          cie.getConstructor()
              .getDeclaringType()
              .getASupertype*()
              .hasQualifiedName("javax.ws.rs.core", "Cookie") or
          cie.getConstructor()
              .getDeclaringType()
              .getASupertype*()
              .hasQualifiedName("jakarta.ws.rs.core", "Cookie")
        ) and
        DataFlow::localExprFlow(this, cie.getArgument(0))
      )
      or
      exists(
        SetCookieMethodAccess ma // response.addHeader("Set-Cookie: token=" +authId + ";HttpOnly;Secure")
      |
        DataFlow::localExprFlow(this, ma.getArgument(1))
      )
    )
  }
}

/** Sink of adding a cookie to the HTTP response. */
class CookieResponseSink extends DataFlow::ExprNode {
  CookieResponseSink() {
    exists(MethodAccess ma |
      (
        ma.getMethod() instanceof ResponseAddCookieMethod or
        ma instanceof SetCookieMethodAccess
      ) and
      ma.getAnArgument() = this.getExpr()
    )
  }
}

/** Holds if the `node` is a method call of `setHttpOnly(true)` on a cookie. */
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

/** Holds if the `node` is a method call of `Set-Cookie` header with the `HttpOnly` flag whose cookie name is sensitive. */
predicate setHttpOnlyInSetCookie(DataFlow::Node node) {
  exists(SetCookieMethodAccess sa |
    hasHttpOnlyExpr(node.asExpr()) and
    DataFlow::localExprFlow(node.asExpr(), sa.getArgument(1))
  )
}

/** Holds if the `node` is an invocation of a JAX-RS `NewCookie` constructor that sets `HttpOnly` to true. */
predicate setHttpOnlyInNewCookie(DataFlow::Node node) {
  exists(ClassInstanceExpr cie |
    cie.getConstructor().getDeclaringType().hasName("NewCookie") and
    DataFlow::localExprFlow(node.asExpr(), cie.getArgument(0)) and
    (
      cie.getNumArgument() = 6 and cie.getArgument(5).(BooleanLiteral).getBooleanValue() = true // NewCookie(Cookie cookie, String comment, int maxAge, Date expiry, boolean secure, boolean httpOnly)
      or
      cie.getNumArgument() = 8 and
      cie.getArgument(6).getType() instanceof BooleanType and
      cie.getArgument(7).(BooleanLiteral).getBooleanValue() = true // NewCookie(String name, String value, String path, String domain, String comment, int maxAge, boolean secure, boolean httpOnly)
      or
      cie.getNumArgument() = 10 and cie.getArgument(9).(BooleanLiteral).getBooleanValue() = true // NewCookie(String name, String value, String path, String domain, int version, String comment, int maxAge, Date expiry, boolean secure, boolean httpOnly)
    )
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

/** A taint configuration tracking flow from a sensitive cookie without HttpOnly flag set to its HTTP response. */
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
    // response.addHeader("Set-Cookie: token=" +authId + ";HttpOnly;Secure")
    setHttpOnlyInSetCookie(node)
    or
    // new NewCookie("session-access-key", accessKey, "/", null, null, 0, true, true)
    setHttpOnlyInNewCookie(node)
    or
    // Test class or method
    isTestMethod(node)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(
      ClassInstanceExpr cie // `NewCookie` constructor
    |
      cie.getAnArgument() = pred.asExpr() and
      cie = succ.asExpr() and
      cie.getConstructor().getDeclaringType().hasName("NewCookie")
    )
    or
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
