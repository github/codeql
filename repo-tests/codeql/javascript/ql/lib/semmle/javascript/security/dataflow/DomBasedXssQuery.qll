/**
 * Provides a taint-tracking configuration for reasoning about DOM-based
 * cross-site scripting vulnerabilities.
 */

import javascript
private import semmle.javascript.security.TaintedUrlSuffix
import DomBasedXssCustomizations::DomBasedXss

/**
 * DEPRECATED. Use `HtmlInjectionConfiguration` or `JQueryHtmlOrSelectorInjectionConfiguration`.
 */
deprecated class Configuration = HtmlInjectionConfiguration;

/**
 * DEPRECATED. Use `Vue::VHtmlSourceWrite` instead.
 */
deprecated class VHtmlSourceWrite = Vue::VHtmlSourceWrite;

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
    isOptionallySanitizedEdge(pred, succ)
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
    not source = [DOM::locationRef(), DOM::locationRef().getAPropertyRead()] and
    label.isTaint()
    or
    source = [DOM::locationSource(), DOM::locationRef().getAPropertyRead(["hash", "search"])] and
    label = TaintedUrlSuffix::label()
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof JQueryHtmlOrSelectorSink and label.isTaint()
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node)
    or
    node instanceof Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof SanitizerGuard
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node trg, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    TaintedUrlSuffix::step(src, trg, inlbl, outlbl)
    or
    exists(DataFlow::Node operator |
      StringConcatenation::taintStep(src, trg, operator, _) and
      StringConcatenation::getOperand(operator, 0).getStringValue() = "<" + any(string s) and
      inlbl = TaintedUrlSuffix::label() and
      outlbl.isTaint()
    )
  }
}
