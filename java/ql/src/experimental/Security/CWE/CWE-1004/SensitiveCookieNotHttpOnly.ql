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
import semmle.code.java.dataflow.TaintTracking2
import DataFlow::PathGraph

/** Gets a regular expression for matching common names of sensitive cookies. */
string getSensitiveCookieNameRegex() { result = "(?i).*(auth|session|token|key|credential).*" }

/** Gets a regular expression for matching CSRF cookies. */
string getCsrfCookieNameRegex() { result = "(?i).*(csrf).*" }

/**
 * Holds if a string is concatenated with the name of a sensitive cookie. Excludes CSRF cookies since
 * they are special cookies implementing the Synchronizer Token Pattern that can be used in JavaScript.
 */
predicate isSensitiveCookieNameExpr(Expr expr) {
  exists(string s | s = expr.(CompileTimeConstantExpr).getStringValue().toLowerCase() |
    s.regexpMatch(getSensitiveCookieNameRegex()) and not s.regexpMatch(getCsrfCookieNameRegex())
  )
  or
  isSensitiveCookieNameExpr(expr.(AddExpr).getAnOperand())
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

/**
 * A taint configuration tracking flow from the text `httponly` to argument 1 of
 * `SetCookieMethodAccess`.
 */
class MatchesHttpOnlyConfiguration extends TaintTracking2::Configuration {
  MatchesHttpOnlyConfiguration() { this = "MatchesHttpOnlyConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(CompileTimeConstantExpr).getStringValue().toLowerCase().matches("%httponly%")
  }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(SetCookieMethodAccess ma).getArgument(1)
  }
}

/** The cookie class of Java EE. */
class CookieClass extends RefType {
  CookieClass() {
    this.getASupertype*()
        .hasQualifiedName(["javax.servlet.http", "javax.ws.rs.core", "jakarta.ws.rs.core"], "Cookie")
  }
}

/** Holds if the `Expr` expr is evaluated to boolean true. */
predicate isBooleanTrue(Expr expr) {
  expr.(CompileTimeConstantExpr).getBooleanValue() = true or
  expr.(VarAccess).getVariable().getAnAssignedValue().(CompileTimeConstantExpr).getBooleanValue() =
    true
}

/** Holds if the method call sets the `HttpOnly` flag. */
predicate setHttpOnlyInCookie(MethodAccess ma) {
  ma.getMethod().getName() = "setHttpOnly" and
  (
    isBooleanTrue(ma.getArgument(0)) // boolean literal true
    or
    exists(
      MethodAccess mpa, int i // runtime assignment of boolean value true
    |
      TaintTracking::localTaint(DataFlow::parameterNode(mpa.getMethod().getParameter(i)),
        DataFlow::exprNode(ma.getArgument(0))) and
      isBooleanTrue(mpa.getArgument(i))
    )
  )
}

/**
 * A taint configuration tracking flow of a method or a wrapper method that sets
 * the `HttpOnly` flag.
 */
class SetHttpOnlyInCookieConfiguration extends TaintTracking2::Configuration {
  SetHttpOnlyInCookieConfiguration() { this = "SetHttpOnlyInCookieConfiguration" }

  override predicate isSource(DataFlow::Node source) { any() }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() =
      any(MethodAccess ma | ma.getMethod() instanceof ResponseAddCookieMethod).getArgument(0)
  }
}

/** Holds if the method call removes a cookie. */
predicate removeCookie(MethodAccess ma) {
  ma.getMethod().getName() = "setMaxAge" and
  ma.getArgument(0).(IntegerLiteral).getIntValue() = 0
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
          MethodAccess ma2 // a method or wrapper method that invokes cookie.setHttpOnly(true)
        |
          (
            setHttpOnlyInCookie(ma2) or
            removeCookie(ma2)
          ) and
          exists(SetHttpOnlyInCookieConfiguration cc |
            cc.hasFlow(DataFlow::exprNode(ma2.getQualifier()), this)
          )
        )
        or
        ma instanceof SetCookieMethodAccess and
        this.getExpr() = ma.getArgument(1) and
        not exists(MatchesHttpOnlyConfiguration cc | cc.hasFlowToExpr(ma.getArgument(1))) // response.addHeader("Set-Cookie", "token=" +authId + ";HttpOnly;Secure")
      ) and
      not isTestMethod(ma) // Test class or method
    )
  }
}

/**
 * Holds if `ClassInstanceExpr` cie is an invocation of a JAX-RS `NewCookie` constructor
 * that sets `HttpOnly` to true.
 */
predicate setHttpOnlyInNewCookie(ClassInstanceExpr cie) {
  cie.getConstructedType().hasQualifiedName(["javax.ws.rs.core", "jakarta.ws.rs.core"], "NewCookie") and
  (
    cie.getNumArgument() = 6 and
    isBooleanTrue(cie.getArgument(5)) // NewCookie(Cookie cookie, String comment, int maxAge, Date expiry, boolean secure, boolean httpOnly)
    or
    cie.getNumArgument() = 8 and
    cie.getArgument(6).getType() instanceof BooleanType and
    isBooleanTrue(cie.getArgument(7)) // NewCookie(String name, String value, String path, String domain, String comment, int maxAge, boolean secure, boolean httpOnly)
    or
    cie.getNumArgument() = 10 and
    isBooleanTrue(cie.getArgument(9)) // NewCookie(String name, String value, String path, String domain, int version, String comment, int maxAge, Date expiry, boolean secure, boolean httpOnly)
  )
}

/** The cookie constructor. */
class CookieTaintPreservingConstructor extends Constructor, TaintPreservingCallable {
  CookieTaintPreservingConstructor() { this.getDeclaringType() instanceof CookieClass }

  override predicate returnsTaintFrom(int arg) { arg = 0 }
}

/** The method call `toString` to get a stringified cookie representation. */
class CookieToString extends TaintPreservingCallable {
  CookieToString() {
    this.getDeclaringType() instanceof CookieClass and
    this.hasName("toString")
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
}

/**
 * Holds if the MethodAccess `ma` is a test method call indicated by:
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
