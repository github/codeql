/**
 * Provides a taint tracking configuration for reasoning about shell command
 * constructed from library input vulnerabilities
 *
 * Note, for performance reasons: only import this file if
 *  `UnsafeShellCommandConstructionFlow` is needed, otherwise
 * `UnsafeShellCommandConstructionCustomizations` should be imported instead.
 */

import codeql.ruby.DataFlow
import UnsafeShellCommandConstructionCustomizations::UnsafeShellCommandConstruction
private import codeql.ruby.TaintTracking
private import CommandInjectionCustomizations::CommandInjection as CommandInjection
private import codeql.ruby.dataflow.BarrierGuards

private module UnsafeShellCommandConstructionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof Source and
    not source instanceof LibraryInputAsSource
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof CommandInjection::Sanitizer or // using all sanitizers from `rb/command-injection`
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getStringConstruction().getLocation()
    or
    result = sink.(Sink).getCommandExecution().getLocation()
  }
}

private module UnsafeShellCommandConstructionLibraryInputConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LibraryInputAsSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof CommandInjection::Sanitizer or // using all sanitizers from `rb/command-injection`
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(Sink).getLocation()
    or
    result = sink.(Sink).getStringConstruction().getLocation()
    or
    result = sink.(Sink).getCommandExecution().getLocation()
  }
}

/**
 * Taint-tracking for detecting shell command constructed from library input vulnerabilities.
 */
private module UnsafeShellCommandConstructionDefaultFlow =
  TaintTracking::Global<UnsafeShellCommandConstructionConfig>;

private module UnsafeShellCommandConstructionLibraryInputFlow =
  TaintTracking::Global<UnsafeShellCommandConstructionLibraryInputConfig>;

module UnsafeShellCommandConstructionFlow =
  DataFlow::MergePathGraph<UnsafeShellCommandConstructionDefaultFlow::PathNode,
    UnsafeShellCommandConstructionLibraryInputFlow::PathNode,
    UnsafeShellCommandConstructionDefaultFlow::PathGraph,
    UnsafeShellCommandConstructionLibraryInputFlow::PathGraph>;

predicate unsafeShellCommandConstructionFlowPath(
  UnsafeShellCommandConstructionFlow::PathNode source,
  UnsafeShellCommandConstructionFlow::PathNode sink
) {
  UnsafeShellCommandConstructionDefaultFlow::flowPath(source.asPathNode1(), sink.asPathNode1())
  or
  UnsafeShellCommandConstructionLibraryInputFlow::flowPath(source.asPathNode2(), sink.asPathNode2())
}
