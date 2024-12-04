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
