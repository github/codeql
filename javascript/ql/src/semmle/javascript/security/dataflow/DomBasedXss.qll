/**
 * Provides a taint-tracking configuration for reasoning about DOM-based
 * cross-site scripting vulnerabilities.
 */

import javascript

module DomBasedXss {
  import DomBasedXssCustomizations::DomBasedXss

  /**
   * A taint-tracking configuration for reasoning about XSS.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "DomBasedXss" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node)
      or
      node instanceof Sanitizer
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
      guard instanceof SanitizerGuard
    }

    override predicate isAdditionalLoadStoreStep(
      DataFlow::Node pred, DataFlow::Node succ, string predProp, string succProp
    ) {
      exists(DataFlow::PropRead read |
        pred = read.getBase() and
        succ = read and
        read.getPropertyName() = "hash" and
        predProp = "hash" and
        succProp = urlSuffixPseudoProperty()
      )
    }

    override predicate isAdditionalLoadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      exists(DataFlow::MethodCallNode call, string name |
        name = "substr" or name = "substring" or name = "slice"
      |
        call.getMethodName() = name and
        not call.getArgument(0).getIntValue() = 0 and
        pred = call.getReceiver() and
        succ = call and
        prop = urlSuffixPseudoProperty()
      )
    }

    override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
      DomBasedXss::isOptionallySanitizedEdge(pred, succ)
    }
  }

  private string urlSuffixPseudoProperty() { result = "$UrlSuffix$" }
}
