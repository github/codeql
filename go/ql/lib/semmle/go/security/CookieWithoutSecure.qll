/** Provides classes and predicates for identifying HTTP cookies without the `Secure` attribute. */

import go
import semmle.go.concepts.HTTP
import semmle.go.dataflow.DataFlow

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

/** Holds if `cw` has the `Secure` attribute left at its default value of `false`. */
predicate isInsecureDefault(Http::CookieWrite cw) {
  not BooleanCookieSecureFlow::flowTo(cw.getSecure())
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
