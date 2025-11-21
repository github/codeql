/**
 * @name Sensitive cookies without the HttpOnly response header set
 * @description A sensitive cookie without the 'HttpOnly' flag set may be vulnerable to
 *              an XSS attack.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @security-severity 5.0
 * @id java/sensitive-cookie-not-httponly
 * @tags security
 *       external/cwe/cwe-1004
 */

/*
 * Sketch of the structure of this query: we track cookie names that appear to be sensitive
 * (e.g. `session` or `token`) to a `ServletResponse.addHeader(...)` or `.addCookie(...)`
 * method that does not set the `httpOnly` flag. Subsidiary configurations
 * `MatchesHttpOnlyToRawHeaderConfig` and `SetHttpOnlyInCookieConfig` are used to establish
 * when the `httpOnly` flag is likely to have been set, before configuration
 * `MissingHttpOnlyConfig` establishes that a non-`httpOnly` cookie has a sensitive-seeming name.
 */

import java
import semmle.code.java.dataflow.FlowSteps
import semmle.code.java.frameworks.Servlets
import semmle.code.java.dataflow.TaintTracking

/** Gets a regular expression for matching common names of sensitive cookies. */
string getSensitiveCookieNameRegex() { result = "(?i).*(auth|session|token|key|credential).*" }

/** Gets a regular expression for matching CSRF cookies. */
string getCsrfCookieNameRegex() { result = "(?i).*(csrf).*" }

/**
 * Holds if a string is concatenated with the name of a sensitive cookie. Excludes CSRF cookies since
 * they are special cookies implementing the Synchronizer Token Pattern that can be used in JavaScript.
 */
predicate isSensitiveCookieNameExpr(Expr expr) {
  exists(string s | s = expr.(CompileTimeConstantExpr).getStringValue() |
    s.regexpMatch(getSensitiveCookieNameRegex()) and not s.regexpMatch(getCsrfCookieNameRegex())
  )
  or
  isSensitiveCookieNameExpr(expr.(AddExpr).getAnOperand())
}

/** A sensitive cookie name. */
class SensitiveCookieNameExpr extends Expr {
  SensitiveCookieNameExpr() { isSensitiveCookieNameExpr(this) }
}

/** A method call that sets a `Set-Cookie` header. */
class SetCookieRawHeaderMethodCall extends MethodCall {
  SetCookieRawHeaderMethodCall() {
    (
      this.getMethod() instanceof ResponseAddHeaderMethod or
      this.getMethod() instanceof ResponseSetHeaderMethod
    ) and
    this.getArgument(0).(CompileTimeConstantExpr).getStringValue().toLowerCase() = "set-cookie"
  }
}

/**
 * A taint configuration tracking flow from the text `httponly` to argument 1 of
 * `SetCookieRawHeaderMethodCall`.
 */
module MatchesHttpOnlyToRawHeaderConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(CompileTimeConstantExpr).getStringValue().toLowerCase().matches("%httponly%")
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(SetCookieRawHeaderMethodCall ma).getArgument(1)
  }
}

module MatchesHttpOnlyToRawHeaderFlow = TaintTracking::Global<MatchesHttpOnlyToRawHeaderConfig>;

/** A class descended from `javax.servlet.http.Cookie`. */
class CookieClass extends RefType {
  CookieClass() { this.getAnAncestor().hasQualifiedName("javax.servlet.http", "Cookie") }
}

/** Holds if `expr` is any boolean-typed expression other than literal `false`. */
// Inlined because this could be a very large result set if computed out of context
pragma[inline]
predicate mayBeBooleanTrue(Expr expr) {
  expr.getType() instanceof BooleanType and
  not expr.(CompileTimeConstantExpr).getBooleanValue() = false
}

/** Holds if the method call may set the `HttpOnly` flag. */
predicate setsCookieHttpOnly(MethodCall ma) {
  ma.getMethod().getName() = "setHttpOnly" and
  // any use of setHttpOnly(x) where x isn't false is probably safe
  mayBeBooleanTrue(ma.getArgument(0))
}

/** Holds if `ma` removes a cookie. */
predicate removesCookie(MethodCall ma) {
  ma.getMethod().getName() = "setMaxAge" and
  ma.getArgument(0).(IntegerLiteral).getIntValue() = 0
}

/**
 * A taint configuration tracking the flow of a cookie that has had the
 * `HttpOnly` flag set, or has been removed, to a `ServletResponse.addCookie`
 * call.
 */
module SetHttpOnlyOrRemovesCookieToAddCookieConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() =
      any(MethodCall ma | setsCookieHttpOnly(ma) or removesCookie(ma)).getQualifier()
  }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr() =
      any(MethodCall ma | ma.getMethod() instanceof ResponseAddCookieMethod).getArgument(0)
  }
}

module SetHttpOnlyOrRemovesCookieToAddCookieFlow =
  TaintTracking::Global<SetHttpOnlyOrRemovesCookieToAddCookieConfig>;

/**
 * A cookie that is added to an HTTP response and which doesn't have `HttpOnly` set, used as a sink
 * in `MissingHttpOnlyConfig`.
 */
class CookieResponseWithoutHttpOnlySink extends DataFlow::ExprNode {
  CookieResponseWithoutHttpOnlySink() {
    exists(MethodCall ma |
      (
        ma.getMethod() instanceof ResponseAddCookieMethod and
        this.getExpr() = ma.getArgument(0) and
        not SetHttpOnlyOrRemovesCookieToAddCookieFlow::flowTo(this)
        or
        ma instanceof SetCookieRawHeaderMethodCall and
        this.getExpr() = ma.getArgument(1) and
        not MatchesHttpOnlyToRawHeaderFlow::flowTo(this) // response.addHeader("Set-Cookie", "token=" +authId + ";HttpOnly;Secure")
      )
    )
  }
}

/** Holds if `cie` is an invocation of a JAX-RS `NewCookie` constructor that sets `HttpOnly` to true. */
predicate setsHttpOnlyInNewCookie(ClassInstanceExpr cie) {
  cie.getConstructedType().hasQualifiedName(["javax.ws.rs.core", "jakarta.ws.rs.core"], "NewCookie") and
  (
    cie.getNumArgument() = 6 and
    mayBeBooleanTrue(cie.getArgument(5)) // NewCookie(Cookie cookie, String comment, int maxAge, Date expiry, boolean secure, boolean httpOnly)
    or
    cie.getNumArgument() = 8 and
    cie.getArgument(6).getType() instanceof BooleanType and
    mayBeBooleanTrue(cie.getArgument(7)) // NewCookie(String name, String value, String path, String domain, String comment, int maxAge, boolean secure, boolean httpOnly)
    or
    cie.getNumArgument() = 10 and
    mayBeBooleanTrue(cie.getArgument(9)) // NewCookie(String name, String value, String path, String domain, int version, String comment, int maxAge, Date expiry, boolean secure, boolean httpOnly)
  )
}

/**
 * A taint configuration tracking flow from a sensitive cookie without the `HttpOnly` flag
 * set to an HTTP response.
 *
 * Tracks string literals containing sensitive names (`SensitiveCookieNameExpr`), to an `addCookie` call (as a `Cookie` object)
 * or an `addHeader` call (as a string) (`CookieResponseWithoutHttpOnlySink`).
 *
 * Passes through `Cookie` constructors and `toString` calls.
 */
module MissingHttpOnlyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof SensitiveCookieNameExpr }

  predicate isSink(DataFlow::Node sink) { sink instanceof CookieResponseWithoutHttpOnlySink }

  predicate isBarrier(DataFlow::Node node) {
    // JAX-RS's `new NewCookie("session-access-key", accessKey, "/", null, null, 0, true, true)` and similar
    // Cookie constructors that set the `HttpOnly` flag are considered barriers to the flow of sensitive names.
    setsHttpOnlyInNewCookie(node.asExpr())
  }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(
      ConstructorCall cc // new Cookie(...)
    |
      cc.getConstructedType() instanceof CookieClass and
      pred.asExpr() = cc.getAnArgument() and
      succ.asExpr() = cc
    )
    or
    exists(
      MethodCall ma // cookie.toString()
    |
      ma.getMethod().getName() = "toString" and
      ma.getQualifier().getType() instanceof CookieClass and
      pred.asExpr() = ma.getQualifier() and
      succ.asExpr() = ma
    )
  }
}

module MissingHttpOnlyFlow = TaintTracking::Global<MissingHttpOnlyConfig>;

import MissingHttpOnlyFlow::PathGraph

from MissingHttpOnlyFlow::PathNode source, MissingHttpOnlyFlow::PathNode sink
where MissingHttpOnlyFlow::flowPath(source, sink)
select sink, source, sink, "$@ doesn't have the HttpOnly flag set.", source, "This sensitive cookie"
