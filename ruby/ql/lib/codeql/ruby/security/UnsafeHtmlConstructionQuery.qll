/**
 * Provides a taint-tracking configuration for reasoning about HTML
 * constructed from library input vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeHtmlConstructionFlow` is needed, otherwise
 * `UnsafeHtmlConstructionCustomizations` should be imported instead.
 */

import codeql.ruby.DataFlow
import UnsafeHtmlConstructionCustomizations::UnsafeHtmlConstruction
private import codeql.ruby.TaintTracking
private import codeql.ruby.dataflow.BarrierGuards

private module UnsafeHtmlConstructionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  // override to require the path doesn't have unmatched return steps
  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getXssSink().getLocation()
  }
}

/**
 * Taint-tracking for detecting unsafe HTML construction.
 */
module UnsafeHtmlConstructionFlow = TaintTracking::Global<UnsafeHtmlConstructionConfig>;
