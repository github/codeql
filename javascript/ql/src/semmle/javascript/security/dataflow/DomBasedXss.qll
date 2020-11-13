/**
 * Provides a taint-tracking configuration for reasoning about DOM-based
 * cross-site scripting vulnerabilities.
 */

import javascript

module DomBasedXss {
  import DomBasedXssCustomizations::DomBasedXss

  /**
   * DEPRECATED. Use `HtmlInjectionConfiguration` or `JQueryHtmlOrSelectorInjectionConfiguration`.
   */
  deprecated class Configuration = HtmlInjectionConfiguration;

  /**
   * A taint-tracking configuration for reasoning about XSS.
   */
  class HtmlInjectionConfiguration extends TaintTracking::Configuration {
    HtmlInjectionConfiguration() { this = "HtmlInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink and
      not sink instanceof JQueryHtmlOrSelectorSink // Handled by JQueryHtmlOrSelectorInjectionConfiguration below
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node)
      or
      node instanceof Sanitizer
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
      guard instanceof SanitizerGuard
    }

    override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
      DomBasedXss::isOptionallySanitizedEdge(pred, succ)
    }
  }

  /**
   * A taint-tracking configuration for reasoning about injection into the jQuery `$` function
   * or similar, where the interpretation of the input string depends on its first character.
   *
   * Values are only considered tainted if they can start with the `<` character.
   */
  class JQueryHtmlOrSelectorInjectionConfiguration extends TaintTracking::Configuration {
    JQueryHtmlOrSelectorInjectionConfiguration() { this = "JQueryHtmlOrSelectorInjection" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      // Reuse any source not derived from location
      source instanceof Source and
      not source = DOM::locationRef() and
      label.isTaint()
      or
      source = DOM::locationSource() and
      label.isData() // Require transformation before reaching sink
      or
      source = DOM::locationRef().getAPropertyRead(["hash", "search"]) and
      label.isData() // Require transformation before reaching sink
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      sink instanceof JQueryHtmlOrSelectorSink and label.isTaint()
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel predlbl,
      DataFlow::FlowLabel succlbl
    ) {
      exists(TaintTracking::AdditionalTaintStep step |
        step.step(pred, succ) and
        predlbl.isData() and
        succlbl.isTaint()
      )
    }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node)
      or
      node instanceof Sanitizer
    }

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
      guard instanceof SanitizerGuard
    }

    override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
      DomBasedXss::isOptionallySanitizedEdge(pred, succ)
      or
      // Avoid stepping from location -> location.hash, as the .hash is already treated as a source
      // (with a different flow label)
      exists(DataFlow::PropRead read |
        read = DOM::locationRef().getAPropertyRead(["hash", "search"]) and
        pred = read.getBase() and
        succ = read
      )
    }
  }
}
