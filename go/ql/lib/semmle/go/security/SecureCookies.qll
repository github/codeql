/** Provides classes and predicates for identifying HTTP cookies with insecure attributes. */

import go
import semmle.go.concepts.HTTP
import semmle.go.dataflow.DataFlow

/**
 * Holds if the expression or its value has a sensitive name
 */
private predicate isSensitiveExpr(Expr expr, string val) {
  (
    val = expr.getStringValue() or
    val = expr.(Name).getTarget().getName()
  ) and
  val.regexpMatch("(?i).*(session|login|token|user|auth|credential).*") and
  not val.regexpMatch("(?i).*(xsrf|csrf|forgery).*")
}

private module SensitiveCookieNameConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isSensitiveExpr(source.asExpr(), _) }

  predicate isSink(DataFlow::Node sink) { exists(Http::CookieWrite cw | sink = cw.getName()) }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Http::CookieOptions co | co.getName() = pred and co.getCookieOutput() = succ)
  }
}

/** Tracks flow from sensitive names to HTTP cookie writes. */
module SensitiveCookieNameFlow = DataFlow::Global<SensitiveCookieNameConfig>;

private module BooleanCookieSecureConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { exists(source.asExpr().getBoolValue()) }

  predicate isSink(DataFlow::Node sink) { exists(Http::CookieWrite cw | sink = cw.getSecure()) }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Http::CookieOptions co | co.getSecure() = pred and co.getCookieOutput() = succ)
  }
}

/** Tracks flow from boolean expressions to the `Secure` attribute HTTP cookie writes. */
module BooleanCookieSecureFlow = DataFlow::Global<BooleanCookieSecureConfig>;

private module BooleanCookieHttpOnlyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { exists(source.asExpr().getBoolValue()) }

  predicate isSink(DataFlow::Node sink) { exists(Http::CookieWrite cw | sink = cw.getHttpOnly()) }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Http::CookieOptions co | co.getHttpOnly() = pred and co.getCookieOutput() = succ)
  }
}

/** Tracks flow from boolean expressions to the `HttpOnly` attribute HTTP cookie writes. */
module BooleanCookieHttpOnlyFlow = DataFlow::Global<BooleanCookieHttpOnlyConfig>;

predicate isInsecureDefault(Http::CookieWrite cw) {
  not BooleanCookieSecureFlow::flow(_, cw.getSecure())
}

predicate isNonHttpOnlyDefault(Http::CookieWrite cw) {
  not BooleanCookieHttpOnlyFlow::flow(_, cw.getHttpOnly())
}

predicate isInsecureDirect(Http::CookieWrite cw, Expr boolFalse) {
  BooleanCookieSecureFlow::flow(DataFlow::exprNode(boolFalse), cw.getSecure()) and
  boolFalse.getBoolValue() = false
}

predicate isNonHttpOnlyDirect(Http::CookieWrite cw, Expr boolFalse) {
  BooleanCookieHttpOnlyFlow::flow(DataFlow::exprNode(boolFalse), cw.getHttpOnly()) and
  boolFalse.getBoolValue() = false
}

predicate isSensitiveCookie(Http::CookieWrite cw, Expr nameExpr, string name) {
  SensitiveCookieNameFlow::flow(DataFlow::exprNode(nameExpr), cw.getName()) and
  isSensitiveExpr(nameExpr, name)
}
