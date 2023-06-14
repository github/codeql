/**
 * Provides a taint tracking configuration for reasoning about shell command
 * constructed from library input vulnerabilities
 *
 * Note, for performance reasons: only import this file if `Configuration` is needed,
 * otherwise `UnsafeShellCommandConstructionCustomizations` should be imported instead.
 */

import codeql.ruby.DataFlow
import UnsafeShellCommandConstructionCustomizations::UnsafeShellCommandConstruction
private import codeql.ruby.TaintTracking
private import CommandInjectionCustomizations::CommandInjection as CommandInjection
private import codeql.ruby.dataflow.BarrierGuards

/**
 * A taint-tracking configuration for detecting shell command constructed from library input vulnerabilities.
 */
module ConfigurationInst = TaintTracking::Global<ConfigurationImpl>;

private module ConfigurationImpl implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof CommandInjection::Sanitizer or // using all sanitizers from `rb/command-injection`
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  // override to require the path doesn't have unmatched return steps
  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet set) {
    // allow implicit reads of array elements
    isSink(node) and
    set.isElementOfTypeOrUnknown("int")
  }
}
