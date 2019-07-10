/**
 * Provides a `DataFlow3` module, which is a copy of the `DataFlow` module. Use
 * this class when data-flow configurations must depend on each other. Two
 * classes extending `DataFlow::Configuration` should never depend on each
 * other, but one of them should instead depend on a
 * `DataFlow2::Configuration`, a `DataFlow3::Configuration`, or a
 * `DataFlow4::Configuration`.
 *
 * See `semmle.code.cpp.dataflow.DataFlow` for the full documentation.
 */
import cpp

module DataFlow3 {
  import semmle.code.cpp.ir.dataflow.internal.DataFlowImpl3

  /**
   * This class exists to prevent mutual recursion between the user-overridden
   * member predicates of `Configuration` and the rest of the data-flow library.
   * Good performance cannot be guaranteed in the presence of such recursion, so
   * it should be replaced by using more than one copy of the data flow library.
   * Four copies are available: `DataFlow` through `DataFlow4`.
   */
  private abstract
  class ConfigurationRecursionPrevention extends Configuration {
    bindingset[this]
    ConfigurationRecursionPrevention() { any() }

    override predicate hasFlow(Node source, Node sink) {
      strictcount(Node n | this.isSource(n)) < 0
      or
      strictcount(Node n | this.isSink(n)) < 0
      or
      strictcount(Node n1, Node n2 | this.isAdditionalFlowStep(n1, n2)) < 0
      or
      super.hasFlow(source, sink)
    }
  }
}
