/**
 * Provides a taint tracking configuration for reasoning about
 * incomplete HTML sanitization vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `IncompleteHtmlAttributeSanitization::Configuration` is needed, otherwise
 * `IncompleteHtmlAttributeSanitizationCustomizations` should be imported instead.
 */

import javascript
import IncompleteHtmlAttributeSanitizationCustomizations::IncompleteHtmlAttributeSanitization

private module Label {
  class Quote extends DataFlow::FlowLabel {
    Quote() { this = ["\"", "'"] }
  }

  class Ampersand extends DataFlow::FlowLabel {
    Ampersand() { this = "&" }
  }

  DataFlow::FlowLabel characterToLabel(string c) { c = result }
}

/**
 * A taint-tracking configuration for reasoning about incomplete HTML sanitization vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "IncompleteHtmlAttributeSanitization" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    label = Label::characterToLabel(source.(Source).getAnUnsanitizedCharacter())
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    label = Label::characterToLabel(sink.(Sink).getADangerousCharacter())
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
    DataFlow::FlowLabel dstlabel
  ) {
    super.isAdditionalFlowStep(src, dst) and srclabel = dstlabel
  }

  override predicate isLabeledBarrier(DataFlow::Node node, DataFlow::FlowLabel lbl) {
    lbl = Label::characterToLabel(node.(StringReplaceCall).getAReplacedString()) or
    isSanitizer(node)
  }

  override predicate isSanitizer(DataFlow::Node n) {
    n instanceof Sanitizer or
    super.isSanitizer(n)
  }
}
