/** Provides classes and predicates for identifying HTTP cookies with insecure attributes. */

import go
import semmle.go.concepts.HTTP
import semmle.go.dataflow.DataFlow

private module SensitiveCookieNameConfig implements DataFlow::ConfigSig {
  /**
   * Holds if `source` is an expression with a name or literal value `val` indicating a sensitive cookie.
   */
  additional predicate isSource(DataFlow::Node source, string val) {
    (
      val = source.asExpr().getStringValue() or
      val = source.asExpr().(Name).getTarget().getName()
    ) and
    val.regexpMatch("(?i).*(session|login|token|user|auth|credential).*") and
    not val.regexpMatch("(?i).*(xsrf|csrf|forgery).*")
  }

  predicate isSource(DataFlow::Node source) { isSource(source, _) }

  additional predicate isSink(DataFlow::Node sink, Http::CookieWrite cw) { sink = cw.getName() }

  predicate isSink(DataFlow::Node sink) { isSink(sink, _) }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Http::CookieOptionWrite co | co.getName() = pred and co.getCookieOutput() = succ)
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
    exists(Http::CookieOptionWrite co | co.getSecure() = pred and co.getCookieOutput() = succ)
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
    exists(Http::CookieOptionWrite co | co.getHttpOnly() = pred and co.getCookieOutput() = succ)
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
  Http::CookieWrite cw, string name, SensitiveCookieNameFlow::PathNode source,
  SensitiveCookieNameFlow::PathNode sink
) {
  SensitiveCookieNameFlow::flowPath(source, sink) and
  SensitiveCookieNameConfig::isSource(source.getNode(), name) and
  SensitiveCookieNameConfig::isSink(sink.getNode(), cw)
}
