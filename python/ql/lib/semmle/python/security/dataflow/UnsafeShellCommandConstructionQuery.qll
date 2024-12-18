/**
 * Provides a taint tracking configuration for reasoning about shell command
 * constructed from library input vulnerabilities
 *
 * Note, for performance reasons: only import this file if `Configuration` is needed,
 * otherwise `UnsafeShellCommandConstructionCustomizations` should be imported instead.
 */

import python
import semmle.python.dataflow.new.DataFlow
import UnsafeShellCommandConstructionCustomizations::UnsafeShellCommandConstruction
private import semmle.python.dataflow.new.TaintTracking
private import CommandInjectionCustomizations::CommandInjection as CommandInjection
private import semmle.python.dataflow.new.BarrierGuards

/**
 * A taint-tracking configuration for detecting "shell command constructed from library input" vulnerabilities.
 */
module UnsafeShellCommandConstructionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer or
    node instanceof CommandInjection::Sanitizer // using all sanitizers from `py/command-injection`
  }

  // override to require the path doesn't have unmatched return steps
  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }
}

/** Global taint-tracking for detecting "shell command constructed from library input" vulnerabilities. */
module UnsafeShellCommandConstructionFlow =
  TaintTracking::Global<UnsafeShellCommandConstructionConfig>;
