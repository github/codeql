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
  predicate isSource(DataFlow::Node source) {
    source instanceof Source and
    not source instanceof LibraryInputAsSource
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getCodeSink().getLocation()
  }
}

private module UnsafeCodeConstructionLibraryInputConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LibraryInputAsSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
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
 * Taint-tracking for detecting code constructed from library input vulnerabilities.
 */
private module UnsafeCodeConstructionDefaultFlow =
  TaintTracking::Global<UnsafeCodeConstructionConfig>;

private module UnsafeCodeConstructionLibraryInputFlow =
  TaintTracking::Global<UnsafeCodeConstructionLibraryInputConfig>;

module UnsafeCodeConstructionFlow =
  DataFlow::MergePathGraph<UnsafeCodeConstructionDefaultFlow::PathNode,
    UnsafeCodeConstructionLibraryInputFlow::PathNode, UnsafeCodeConstructionDefaultFlow::PathGraph,
    UnsafeCodeConstructionLibraryInputFlow::PathGraph>;

predicate unsafeCodeConstructionFlowPath(
  UnsafeCodeConstructionFlow::PathNode source, UnsafeCodeConstructionFlow::PathNode sink
) {
  UnsafeCodeConstructionDefaultFlow::flowPath(source.asPathNode1(), sink.asPathNode1())
  or
  UnsafeCodeConstructionLibraryInputFlow::flowPath(source.asPathNode2(), sink.asPathNode2())
}
