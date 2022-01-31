/**
 * Provides a taint-tracking configuration for reasoning about code
 * injection vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `CodeInjection::Configuration` is needed, otherwise
 * `CodeInjectionCustomizations` should be imported instead.
 * Is boosted by ATM.
 */

import javascript
import AdaptiveThreatModeling
import semmle.javascript.security.dataflow.CodeInjectionCustomizations::CodeInjection

/**
 * This module provides logic to filter candidate sinks to those which are likely XSS sinks.
 */
module SinkEndpointFilter {
  private import StandardEndpointFilters as StandardEndpointFilters

  /**
   * Provides a set of reasons why a given data flow node should be excluded as a sink candidate.
   *
   * If this predicate has no results for a sink candidate `n`, then we should treat `n` as an
   * effective sink.
   */
  string getAReasonSinkExcluded(DataFlow::Node sinkCandidate) {
    result = StandardEndpointFilters::getAReasonSinkExcluded(sinkCandidate)
  }
}

class CodeInjectionATMConfig extends ATMConfig {
  CodeInjectionATMConfig() { this = "CodeInjectionATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof Source }

  override predicate isKnownSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    not exists(SinkEndpointFilter::getAReasonSinkExcluded(sinkCandidate))
  }

  override EndpointType getASinkEndpointType() { result instanceof CodeInjectionSinkType }
}

/**
 * A taint-tracking configuration for reasoning about code injection vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "CodeInjectionATMConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) {
    (sink instanceof Sink or any(CodeInjectionATMConfig cfg).isEffectiveSink(sink))
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node trg) {
    // HTML sanitizers are insufficient protection against code injection
    src = trg.(HtmlSanitizerCall).getInput()
  }
}
