/**
 * Provides a taint-tracking configuration for reasoning about code
 * constructed from library input vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `UnsafeCodeConstructionFlow` is needed, otherwise
 * `UnsafeCodeConstructionCustomizations` should be imported instead.
 */

import codeql.ruby.DataFlow
import UnsafeCodeConstructionCustomizations::UnsafeCodeConstruction
private import codeql.ruby.TaintTracking
private import codeql.ruby.dataflow.BarrierGuards

private module UnsafeCodeConstructionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  // override to require the path doesn't have unmatched return steps
  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getCodeSink().getLocation()
  }
}

/**
 * Taint-tracking for detecting code constructed from library input vulnerabilities.
 */
module UnsafeCodeConstructionFlow = TaintTracking::Global<UnsafeCodeConstructionConfig>;
