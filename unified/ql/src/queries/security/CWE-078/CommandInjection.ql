/**
 * @name System command built from user-controlled sources
 * @description Building a system command from user-controlled sources may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id unified/swift/command-line-injection
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import unified

/**
 * A taint configuration for tainted data that reaches a command injection sink.
 */
module CommandInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { Models::isSource(node, _) }

  predicate isSink(DataFlow::Node node) {
    // TODO: Support Process property-write sinks from original Swift's CommandInjectionExtensions.qll.
    Models::isSink(node, "command-injection")
  }

  predicate isBarrier(DataFlow::Node node) {
    // TODO: Port the numeric-type barrier from original Swift's CommandInjectionExtensions.qll.
    none()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module CommandInjectionFlow = TaintTracking::Global<CommandInjectionConfig>;

import CommandInjectionFlow::PathGraph

from CommandInjectionFlow::PathNode source, CommandInjectionFlow::PathNode sink
where CommandInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This command depends on a $@.", source.getNode(),
  "user-provided value"
