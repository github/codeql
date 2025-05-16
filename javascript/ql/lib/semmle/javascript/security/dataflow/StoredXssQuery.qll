/**
 * Provides a taint-tracking configuration for reasoning about stored
 * cross-site scripting vulnerabilities.
 */

import javascript
import StoredXssCustomizations::StoredXss
private import Xss::Shared as Shared

/**
 * A taint-tracking configuration for reasoning about stored XSS.
 */
module StoredXssConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or node = Shared::BarrierGuard::getABarrierNode()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about stored XSS.
 */
module StoredXssFlow = TaintTracking::Global<StoredXssConfig>;

private class QuoteGuard extends Shared::QuoteGuard {
  QuoteGuard() { this = this }
}

private class ContainsHtmlGuard extends Shared::ContainsHtmlGuard {
  ContainsHtmlGuard() { this = this }
}
