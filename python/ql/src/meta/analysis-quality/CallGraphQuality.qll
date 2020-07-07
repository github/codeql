/**
 * Provides predicates for measuring the quality of the call graph, that is,
 * the number of calls that could be resolved to a callee.
 */

import python
import meta.MetaMetrics

/**
 * A call that is (possibly) relevant for analysis quality.
 * See `IgnoredFile` for details on what is excluded.
 */
class RelevantCall extends Call {
  RelevantCall() { not this.getLocation().getFile() instanceof IgnoredFile }
}

/** Provides classes for call-graph resolution by using points-to */
module PointsTo {
  /** A call that can be resolved by points-to. */
  class ResolvableCall extends RelevantCall {
    Value target;

    ResolvableCall() { target.getACall() = this.getAFlowNode() }

    /** Gets a resolved target of this call */
    Value getTarget() { result = target }
  }

  /** A call that cannot be resolved by points-to. */
  class UnresolvableCall extends RelevantCall {
    UnresolvableCall() { not this instanceof ResolvableCall }
  }

  /**
   * A call that can be resolved by points-to, where the resolved target is relevant.
   * Relevant targets include:
   * - builtins
   * - standard library
   * - source code of the project
   */
  class ResolvableCallRelevantTarget extends ResolvableCall {
    ResolvableCallRelevantTarget() {
      target.isBuiltin()
      or
      exists(File file |
        file = target.(CallableValue).getScope().getLocation().getFile()
        or
        file = target.(ClassValue).getScope().getLocation().getFile()
      |
        file.inStdlib()
        or
        // part of the source code of the project
        exists(file.getRelativePath())
      )
    }
  }

  /**
   * A call that can be resolved by points-to, where resolved target is not considered relevant.
   * See `ResolvableCallRelevantTarget` for definition of relevance.
   */
  class ResolvableCallIrrelevantTarget extends ResolvableCall {
    ResolvableCallIrrelevantTarget() { not this instanceof ResolvableCallRelevantTarget }
  }
}
