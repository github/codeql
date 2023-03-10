/**
 * Provides a taint-tracking configuration for reasoning about
 * unsafe HTML constructed from library input vulnerabilities.
 */

import javascript
private import semmle.javascript.security.dataflow.DomBasedXssCustomizations::DomBasedXss as DomBasedXss
private import semmle.javascript.security.dataflow.UnsafeJQueryPluginCustomizations::UnsafeJQueryPlugin as UnsafeJQueryPlugin
import UnsafeHtmlConstructionCustomizations::UnsafeHtmlConstruction
import semmle.javascript.security.TaintedObject

/**
 * A taint-tracking configuration for reasoning about unsafe HTML constructed from library input vulnerabilities.
 */
class Configration extends TaintTracking::Configuration {
  Configration() { this = "UnsafeHtmlConstruction" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    source instanceof Source and
    label = [TaintedObject::label(), DataFlow::FlowLabel::taint(), DataFlow::FlowLabel::data()]
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof Sink and
    label = DataFlow::FlowLabel::taint()
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node)
    or
    node instanceof DomBasedXss::Sanitizer
    or
    node instanceof UnsafeJQueryPlugin::Sanitizer
  }

  override predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
    DomBasedXss::isOptionallySanitizedEdge(pred, succ)
  }

  // override to require that there is a path without unmatched return steps
  override predicate hasFlowPath(DataFlow::SourcePathNode source, DataFlow::SinkPathNode sink) {
    super.hasFlowPath(source, sink) and
    DataFlow::hasPathWithoutUnmatchedReturn(source, sink)
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    DataFlow::localFieldStep(pred, succ) and
    inlbl.isTaint() and
    outlbl.isTaint()
    or
    TaintedObject::step(pred, succ, inlbl, outlbl)
    or
    // property read from a tainted object is considered tainted
    succ.(DataFlow::PropRead).getBase() = pred and
    inlbl = TaintedObject::label() and
    outlbl = DataFlow::FlowLabel::taint()
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof QuoteGuard or
    guard instanceof ContainsHtmlGuard or
    guard instanceof TypeTestGuard
  }
}

private import semmle.javascript.security.dataflow.Xss::Shared as Shared

private class QuoteGuard extends TaintTracking::SanitizerGuardNode, Shared::QuoteGuard {
  QuoteGuard() { this = this }
}

private class ContainsHtmlGuard extends TaintTracking::SanitizerGuardNode, Shared::ContainsHtmlGuard
{
  ContainsHtmlGuard() { this = this }
}
