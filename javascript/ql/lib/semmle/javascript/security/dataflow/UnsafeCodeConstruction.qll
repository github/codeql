/**
 * Provides a taint-tracking configuration for reasoning about code
 * constructed from library input vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeCodeConstruction::Configuration` is needed, otherwise
 * `UnsafeCodeConstructionCustomizations` should be imported instead.
 */

import javascript

/**
 * Classes and predicates for the code constructed from library input query.
 */
module UnsafeCodeConstruction {
  private import semmle.javascript.security.dataflow.CodeInjectionCustomizations::CodeInjection as CodeInjection
  import UnsafeCodeConstructionCustomizations::UnsafeCodeConstruction

  /**
   * A taint-tracking configuration for reasoning about unsafe code constructed from library input.
   */
  module UnsafeCodeConstructionConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isBarrier(DataFlow::Node node) { node instanceof CodeInjection::Sanitizer }

    predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      // HTML sanitizers are insufficient protection against code injection
      node1 = node2.(HtmlSanitizerCall).getInput()
    }

    DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }

    predicate observeDiffInformedIncrementalMode() { any() }

    Location getASelectedSinkLocation(DataFlow::Node sink) {
      result = sink.(Sink).getLocation()
      or
      result = sink.(Sink).getCodeSink().getLocation()
    }
  }

  /**
   * Taint-tracking for reasoning about unsafe code constructed from library input.
   */
  module UnsafeCodeConstructionFlow = TaintTracking::Global<UnsafeCodeConstructionConfig>;
}
