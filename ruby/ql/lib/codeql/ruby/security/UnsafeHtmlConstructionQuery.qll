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
  predicate isSource(DataFlow::Node source) {
    source instanceof Source and
    not source instanceof LibraryInputAsSource
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getXssSink().getLocation()
  }
}

private module UnsafeHtmlConstructionLibraryInputConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LibraryInputAsSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

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
private module UnsafeHtmlConstructionDefaultFlow =
  TaintTracking::Global<UnsafeHtmlConstructionConfig>;

private module UnsafeHtmlConstructionLibraryInputFlow =
  TaintTracking::Global<UnsafeHtmlConstructionLibraryInputConfig>;

module UnsafeHtmlConstructionFlow =
  DataFlow::MergePathGraph<UnsafeHtmlConstructionDefaultFlow::PathNode,
    UnsafeHtmlConstructionLibraryInputFlow::PathNode, UnsafeHtmlConstructionDefaultFlow::PathGraph,
    UnsafeHtmlConstructionLibraryInputFlow::PathGraph>;

predicate unsafeHtmlConstructionFlowPath(
  UnsafeHtmlConstructionFlow::PathNode source, UnsafeHtmlConstructionFlow::PathNode sink
) {
  UnsafeHtmlConstructionDefaultFlow::flowPath(source.asPathNode1(), sink.asPathNode1())
  or
  UnsafeHtmlConstructionLibraryInputFlow::flowPath(source.asPathNode2(), sink.asPathNode2())
}
