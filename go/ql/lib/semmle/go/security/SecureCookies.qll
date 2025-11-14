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
module SensitiveCookieNameFlow = TaintTracking::Global<SensitiveCookieNameConfig>;

private module BooleanCookieSecureConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getType().getUnderlyingType() instanceof BoolType
  }

  predicate isSink(DataFlow::Node sink) { exists(Http::CookieWrite cw | sink = cw.getSecure()) }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Http::CookieOptions co | co.getSecure() = pred and co.getCookieOutput() = succ)
  }
}

/** Tracks flow from boolean expressions to the `Secure` attribute of HTTP cookie writes. */
module BooleanCookieSecureFlow = TaintTracking::Global<BooleanCookieSecureConfig>;

private module BooleanCookieHttpOnlyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getType().getUnderlyingType() instanceof BoolType
  }

  predicate isSink(DataFlow::Node sink) { exists(Http::CookieWrite cw | sink = cw.getHttpOnly()) }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Http::CookieOptions co | co.getHttpOnly() = pred and co.getCookieOutput() = succ)
  }
}

/** Tracks flow from boolean expressions to the `HttpOnly` attribute of HTTP cookie writes. */
module BooleanCookieHttpOnlyFlow = TaintTracking::Global<BooleanCookieHttpOnlyConfig>;

/** Holds if `cw` has the `Secure` attribute left at its default value of `false`. */
predicate isInsecureDefault(Http::CookieWrite cw) {
  not BooleanCookieSecureFlow::flow(_, cw.getSecure())
}

/** Holds if `cw` has the `Secure` attribute explicitly set to `false`, from the expression `boolFalse`. */
predicate isInsecureDirect(Http::CookieWrite cw, Expr boolFalse) {
  BooleanCookieSecureFlow::flow(DataFlow::exprNode(boolFalse), cw.getSecure()) and
  boolFalse.getBoolValue() = false
}

/** Holds if `cw` has the `Secure` attribute set to `false`, either explicitly or by default. */
predicate isInsecureCookie(Http::CookieWrite cw) {
  isInsecureDefault(cw) or
  isInsecureDirect(cw, _)
}

/** Holds if `cw` has the `HttpOnly` attribute left at its default value of `false`. */
predicate isNonHttpOnlyDefault(Http::CookieWrite cw) {
  not BooleanCookieHttpOnlyFlow::flow(_, cw.getHttpOnly())
}

/** Holds if `cw` has the `HttpOnly` attribute explicitly set to `false`, from the expression `boolFalse`. */
predicate isNonHttpOnlyDirect(Http::CookieWrite cw, Expr boolFalse) {
  BooleanCookieHttpOnlyFlow::flow(DataFlow::exprNode(boolFalse), cw.getHttpOnly()) and
  boolFalse.getBoolValue() = false
}

/** Holds if `cw` has the `HttpOnly` attribute set to `false`, either explicitly or by default. */
predicate isNonHttpOnlyCookie(Http::CookieWrite cw) {
  isNonHttpOnlyDefault(cw) or
  isNonHttpOnlyDirect(cw, _)
}

/**
 * Holds if `cw` has the sensitive name `name`, from the expression `nameExpr`.
 * `source` and `sink` represent the data flow path from the sensitive name expression to the cookie write.
 */
predicate isSensitiveCookie(
  Http::CookieWrite cw, Expr nameExpr, string name, SensitiveCookieNameFlow::PathNode source,
  SensitiveCookieNameFlow::PathNode sink
) {
  SensitiveCookieNameFlow::flowPath(source, sink) and
  source.getNode().asExpr() = nameExpr and
  sink.getNode() = cw.getName() and
  isSensitiveExpr(nameExpr, name)
}
