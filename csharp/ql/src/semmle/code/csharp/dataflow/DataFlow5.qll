/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */

import csharp

module DataFlow5 {
  import semmle.code.csharp.dataflow.internal.DataFlowImpl5

  /**
   * This class exists to prevent mutual recursion between the user-overridden
   * member predicates of `Configuration` and the rest of the data-flow library.
   * Good performance cannot be guaranteed in the presence of such recursion, so
   * it should be replaced by using more than one copy of the data flow library.
   * Four copies are available: `DataFlow` through `DataFlow4`.
   */
  abstract private class ConfigurationRecursionPrevention extends Configuration {
    bindingset[this]
    ConfigurationRecursionPrevention() { any() }

    override predicate hasFlow(Node source, Node sink) {
      strictcount(Node n | this.isSource(n)) < 0 or
      strictcount(Node n | this.isSink(n)) < 0 or
      strictcount(Node n1, Node n2 | this.isAdditionalFlowStep(n1, n2)) < 0 or
      super.hasFlow(source, sink)
    }
  }
}
