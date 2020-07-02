/**
 * DEPRECATED: Recursion through `DataFlow::Configuration` is impossible in
 * any supported tooling. There is no need for this module because it's
 * impossible to accidentally depend on recursion through
 * `DataFlow::Configuration` in current releases.
 *
 * When this module is imported, recursive use of `DataFlow::Configuration` is
 * disallowed. Importing this module will guarantee the absence of such
 * recursion, which is unsupported and will be unconditionally disallowed in a
 * future release.
 *
 * Recursive use of `DataFlow{2..4}::Configuration` is always disallowed, so no
 * import is needed for those.
 */

import cpp
private import semmle.code.cpp.dataflow.DataFlow

/**
 * This class exists to prevent mutual recursion between the user-overridden
 * member predicates of `Configuration` and the rest of the data-flow library.
 * Good performance cannot be guaranteed in the presence of such recursion, so
 * it should be replaced by using more than one copy of the data flow library.
 * Four copies are available: `DataFlow` through `DataFlow4`.
 */
abstract private class ConfigurationRecursionPrevention extends DataFlow::Configuration {
  bindingset[this]
  ConfigurationRecursionPrevention() { any() }

  override predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
    strictcount(DataFlow::Node n | this.isSource(n)) < 0
    or
    strictcount(DataFlow::Node n | this.isSink(n)) < 0
    or
    strictcount(DataFlow::Node n1, DataFlow::Node n2 | this.isAdditionalFlowStep(n1, n2)) < 0
    or
    super.hasFlow(source, sink)
  }
}
