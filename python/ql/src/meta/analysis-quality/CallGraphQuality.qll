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

/** Provides classes for call-graph resolution by using points-to. */
module PointsToBasedCallGraph {
  /** A call that can be resolved by points-to. */
  class ResolvableCall extends RelevantCall {
    Value callee;

    ResolvableCall() { callee.getACall() = this.getAFlowNode() }

    /** Gets a resolved callee of this call. */
    Value getCallee() { result = callee }
  }

  /** A call that cannot be resolved by points-to. */
  class UnresolvableCall extends RelevantCall {
    UnresolvableCall() { not this instanceof ResolvableCall }
  }

  /**
   * A call that can be resolved by points-to, where the resolved callee is relevant.
   * Relevant callees include:
   * - builtins
   * - standard library
   * - source code of the project
   */
  class ResolvableCallRelevantCallee extends ResolvableCall {
    ResolvableCallRelevantCallee() {
      callee.isBuiltin()
      or
      exists(File file |
        file = callee.(CallableValue).getScope().getLocation().getFile()
        or
        file = callee.(ClassValue).getScope().getLocation().getFile()
      |
        file.inStdlib()
        or
        // part of the source code of the project
        exists(file.getRelativePath())
      )
    }
  }

  /**
   * A call that can be resolved by points-to, where the resolved callee is not considered relevant.
   * See `ResolvableCallRelevantCallee` for the definition of relevance.
   */
  class ResolvableCallIrrelevantCallee extends ResolvableCall {
    ResolvableCallIrrelevantCallee() { not this instanceof ResolvableCallRelevantCallee }
  }
}
