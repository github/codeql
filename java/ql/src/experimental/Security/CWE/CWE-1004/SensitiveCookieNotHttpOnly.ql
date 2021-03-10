/**
 * @name Sensitive cookies without the HttpOnly response header set
 * @description Sensitive cookies without 'HttpOnly' leaves session cookies vulnerable to an XSS attack.
 * @kind path-problem
 * @id java/sensitive-cookie-not-httponly
 * @tags security
 *       external/cwe/cwe-1004
 */

import java
import semmle.code.java.dataflow.FlowSteps
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

/** The cookie class of Java EE. */
class CookieClass extends RefType {
  CookieClass() {
    this.getASupertype*()
        .hasQualifiedName(["javax.servlet.http", "javax.ws.rs.core", "jakarta.ws.rs.core"], "Cookie")
  }
}

/** Sensitive cookie name used in a `Cookie` constructor or a `Set-Cookie` call. */
class SensitiveCookieNameExpr extends Expr {
  SensitiveCookieNameExpr() { isSensitiveCookieNameExpr(this) }
}

/** Sink of adding a cookie to the HTTP response. */
class CookieResponseSink extends DataFlow::ExprNode {
  CookieResponseSink() {
    exists(MethodAccess ma |
      (
        ma.getMethod() instanceof ResponseAddCookieMethod and
        this.getExpr() = ma.getArgument(0) and
        not exists(
          MethodAccess ma2 // cookie.setHttpOnly(true)
        |
          ma2.getMethod().getName() = "setHttpOnly" and
          ma2.getArgument(0).(BooleanLiteral).getBooleanValue() = true and
          DataFlow::localExprFlow(ma2.getQualifier(), this.getExpr())
        )
        or
        ma instanceof SetCookieMethodAccess and
        this.getExpr() = ma.getArgument(1) and
        not hasHttpOnlyExpr(this.getExpr()) // response.addHeader("Set-Cookie", "token=" +authId + ";HttpOnly;Secure")
      ) and
      not isTestMethod(ma) // Test class or method
    )
  }
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

/** The cookie constructor. */
class CookieTaintPreservingConstructor extends Constructor, TaintPreservingCallable {
  CookieTaintPreservingConstructor() { this.getDeclaringType() instanceof CookieClass }

  override predicate returnsTaintFrom(int arg) { arg = 0 }
}

/** The method call `toString` to get a stringified cookie representation. */
class CookieInstanceExpr extends TaintPreservingCallable {
  CookieInstanceExpr() {
    this.getDeclaringType() instanceof CookieClass and
    this.hasName("toString")
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
}

/**
 * Holds if the node is a test method indicated by:
 *    a) in a test directory such as `src/test/java`
 *    b) in a test package whose name has the word `test`
 *    c) in a test class whose name has the word `test`
 *    d) in a test class implementing a test framework such as JUnit or TestNG
 */
predicate isTestMethod(MethodAccess ma) {
  exists(Method m |
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
    // new NewCookie("session-access-key", accessKey, "/", null, null, 0, true, true)
    setHttpOnlyInNewCookie(node.asExpr())
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, MissingHttpOnlyConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ doesn't have the HttpOnly flag set.", source.getNode(),
  "This sensitive cookie"
