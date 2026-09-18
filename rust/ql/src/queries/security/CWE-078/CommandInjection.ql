/**
 * @name Uncontrolled command line
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id rust/command-line-injection
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.CommandInjectionExtensions

/**
 * A taint configuration for detecting command injection vulnerabilities.
 */
module CommandInjectionConfig implements DataFlow::ConfigSig {
  import CommandInjection

  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module CommandInjectionFlow = TaintTracking::Global<CommandInjectionConfig>;

import CommandInjectionFlow::PathGraph

from CommandInjectionFlow::PathNode sourceNode, CommandInjectionFlow::PathNode sinkNode
where CommandInjectionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This command line depends on a $@.",
  sourceNode.getNode(), "user-provided value"
