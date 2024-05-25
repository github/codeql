/**
 * Provides a taint-tracking configuration for detecting "URL redirection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `UrlRedirect::Configuration` is needed, otherwise
 * `UrlRedirectCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import UrlRedirectCustomizations::UrlRedirect as UrlRedirect

/**
 * DEPRECATED: Use `UrlRedirectFlow` module instead.
 *
 * A taint-tracking configuration for detecting "URL redirection" vulnerabilities.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UrlRedirect" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source instanceof UrlRedirect::Source and state instanceof UrlRedirect::MayContainBackslashes
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink instanceof UrlRedirect::Sink and state instanceof UrlRedirect::FlowState
  }

  override predicate isSanitizer(DataFlow::Node node, DataFlow::FlowState state) {
    node.(UrlRedirect::Sanitizer).sanitizes(state)
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node nodeFrom, DataFlow::FlowState stateFrom, DataFlow::Node nodeTo,
    DataFlow::FlowState stateTo
  ) {
    any(UrlRedirect::AdditionalFlowStep a).step(nodeFrom, stateFrom, nodeTo, stateTo)
  }
}

private module UrlRedirectConfig implements DataFlow::StateConfigSig {
  class FlowState = UrlRedirect::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof UrlRedirect::Source and state instanceof UrlRedirect::MayContainBackslashes
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof UrlRedirect::Sink and
    exists(state)
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    node.(UrlRedirect::Sanitizer).sanitizes(state)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
  ) {
    any(UrlRedirect::AdditionalFlowStep a).step(nodeFrom, stateFrom, nodeTo, stateTo)
  }
}

/** Global taint-tracking for detecting "URL redirection" vulnerabilities. */
module UrlRedirectFlow = TaintTracking::GlobalWithState<UrlRedirectConfig>;
