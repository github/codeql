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
private import IncompleteHtmlAttributeSanitizationCustomizations::IncompleteHtmlAttributeSanitization as IncompleteHtmlAttributeSanitization

deprecated private module Label {
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
module IncompleteHtmlAttributeSanitizationConfig implements DataFlow::StateConfigSig {
  class FlowState = IncompleteHtmlAttributeSanitization::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    state = FlowState::character(source.(Source).getAnUnsanitizedCharacter())
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    state = FlowState::character(sink.(Sink).getADangerousCharacter())
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    state = FlowState::character(node.(StringReplaceCall).getAReplacedString())
  }

  predicate isBarrier(DataFlow::Node n) { n instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about incomplete HTML sanitization vulnerabilities.
 */
module IncompleteHtmlAttributeSanitizationFlow =
  TaintTracking::GlobalWithState<IncompleteHtmlAttributeSanitizationConfig>;
