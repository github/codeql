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
private import codeql.ruby.frameworks.core.Array

/**
 * A taint-tracking configuration for detecting shell command constructed from library input vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnsafeShellCommandConstruction" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof CommandInjection::Sanitizer or // using all sanitizers from `rb/command-injection`
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  // override to require the path doesn't have unmatched return steps
  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSourceCallContext
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    // if an array element gets tainted, then we treat the entire array as tainted
    Array::taintedArrayObjectSteps(pred, succ)
  }
}
