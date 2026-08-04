/**
 * Provides a taint tracking configuration for reasoning about
 * missing full-anchored regular expressions.
 *
 * Note, for performance reasons: only import this file if
 * `MissingFullAnchorFlow` is needed, otherwise
 * `MissingFullAnchorCustomizations` should be imported instead.
 */

import ruby
import codeql.ruby.TaintTracking
import MissingFullAnchorCustomizations::MissingFullAnchor

private module MissingFullAnchorConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof Source and
    not source instanceof LibraryInputAsSource
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() {
    none() // can't be made diff-informed because the locations of Ruby RegExpTerms aren't correct when the regexp is parsed from a string arising from constant folding
  }
}

private module MissingFullAnchorLibraryInputConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LibraryInputAsSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }

  predicate observeDiffInformedIncrementalMode() {
    none() // can't be made diff-informed because the locations of Ruby RegExpTerms aren't correct when the regexp is parsed from a string arising from constant folding
  }
}

/**
 * Taint-tracking for reasoning about missing full-anchored regular expressions.
 */
private module MissingFullAnchorDefaultFlow = TaintTracking::Global<MissingFullAnchorConfig>;

private module MissingFullAnchorLibraryInputFlow =
  TaintTracking::Global<MissingFullAnchorLibraryInputConfig>;

module MissingFullAnchorFlow =
  DataFlow::MergePathGraph<MissingFullAnchorDefaultFlow::PathNode,
    MissingFullAnchorLibraryInputFlow::PathNode, MissingFullAnchorDefaultFlow::PathGraph,
    MissingFullAnchorLibraryInputFlow::PathGraph>;

predicate missingFullAnchorFlowPath(
  MissingFullAnchorFlow::PathNode source, MissingFullAnchorFlow::PathNode sink
) {
  MissingFullAnchorDefaultFlow::flowPath(source.asPathNode1(), sink.asPathNode1())
  or
  MissingFullAnchorLibraryInputFlow::flowPath(source.asPathNode2(), sink.asPathNode2())
}
