/**
 * Provides a taint-tracking configuration for reasoning about reflected
 * cross-site scripting vulnerabilities.
 */

import javascript
import ReflectedXssCustomizations::ReflectedXss
private import Xss::Shared as SharedXss

/**
 * A taint-tracking configuration for reasoning about reflected XSS.
 */
module ReflectedXssConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or node = SharedXss::BarrierGuard::getABarrierNode()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about reflected XSS.
 */
module ReflectedXssFlow = TaintTracking::Global<ReflectedXssConfig>;

/**
 * DEPRECATED. Use the `ReflectedXssFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ReflectedXss" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof QuoteGuard or
    guard instanceof ContainsHtmlGuard
  }
}

private class QuoteGuard extends SharedXss::QuoteGuard {
  QuoteGuard() { this = this }
}

private class ContainsHtmlGuard extends SharedXss::ContainsHtmlGuard {
  ContainsHtmlGuard() { this = this }
}
