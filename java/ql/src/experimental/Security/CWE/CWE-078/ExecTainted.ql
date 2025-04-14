/**
 * @name Uncontrolled command line (experimental sinks)
 * @description Using externally controlled strings in a command line is vulnerable to malicious
 *              changes in the strings (includes experimental sinks).
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/command-line-injection-experimental
 * @tags security
 *       experimental
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.CommandLineQuery
import InputToArgumentToExecFlow::PathGraph
private import semmle.code.java.dataflow.ExternalFlow

deprecated private class ActivateModels extends ActiveExperimentalModels {
  ActivateModels() { this = "jsch-os-injection" }
}

// This is a clone of query `java/command-line-injection` that also includes experimental sinks.
deprecated query predicate problems(
  Expr execArg, InputToArgumentToExecFlow::PathNode source,
  InputToArgumentToExecFlow::PathNode sink, string message1, DataFlow::Node sourceNode,
  string message2
) {
  execIsTainted(source, sink, execArg) and
  message1 = "This command line depends on a $@." and
  sourceNode = source.getNode() and
  message2 = "user-provided value"
}
