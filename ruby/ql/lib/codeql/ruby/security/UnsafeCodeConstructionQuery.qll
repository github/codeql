/**
 * Provides a taint-tracking configuration for reasoning about code
 * constructed from library input vulnerabilities.
 *
 * Note, for performance reasons: only import this file if `Configuration` is needed,
 * otherwise `UnsafeCodeConstructionCustomizations` should be imported instead.
 */

import codeql.ruby.DataFlow
import UnsafeCodeConstructionCustomizations::UnsafeCodeConstruction
private import codeql.ruby.TaintTracking
private import codeql.ruby.dataflow.BarrierGuards

/**
 * A taint-tracking configuration for detecting code constructed from library input vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnsafeShellCommandConstruction" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }

  // override to require the path doesn't have unmatched return steps
  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSourceCallContext
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    // if an array element gets tainted, then we treat the entire array as tainted
    exists(DataFlow::CallNode call |
      call.getMethodName() = ["<<", "push", "append"] and
      call.getReceiver() = succ and
      pred = call.getArgument(0) and
      call.getNumberOfArguments() = 1
    )
    or
    exists(DataFlow::CallNode call |
      call.getMethodName() = "[]" and
      succ = call and
      pred = call.getArgument(_)
    )
  }
}
