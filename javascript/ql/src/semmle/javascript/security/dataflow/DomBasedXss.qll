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

    override predicate isAdditionalStoreStep(
      DataFlow::Node pred, DataFlow::SourceNode succ, string prop
    ) {
      exists(DataFlow::PropRead read |
        pred = read.getBase() and
        succ = read and
        read.getPropertyName() = "hash" and
        prop = urlSuffixPseudoProperty()
      )
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
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = ["substr", "substring", "slice"] and
        not call.getArgument(0).getIntValue() = 0 and
        pred = call.getReceiver() and
        succ = call and
        prop = urlSuffixPseudoProperty()
      )
      or
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = "exec" and pred = call.getArgument(0)
        or
        call.getMethodName() = "match" and pred = call.getReceiver()
      |
        succ = call and
        prop = urlSuffixPseudoProperty()
      )
      or
      exists(StringSplitCall split |
        split.getSeparator() = ["#", "?"] and
        pred = split.getBaseString() and
        succ = split.getASubstringRead(1) and
        prop = urlSuffixPseudoProperty()
      )
    }

    override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
      DomBasedXss::isOptionallySanitizedEdge(pred, succ)
    }
  }

  private string urlSuffixPseudoProperty() { result = "$UrlSuffix$" }
}
