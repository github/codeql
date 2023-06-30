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
import semmle.code.java.security.CommandLineQuery
import RemoteUserInputToArgumentToExecFlow::PathGraph
private import semmle.code.java.dataflow.ExternalFlow

private class ActivateModels extends ActiveExperimentalModels {
  ActivateModels() { this = "jsch-os-injection" }
}

// This is a clone of query `java/command-line-injection` that also includes experimental sinks.
from
  RemoteUserInputToArgumentToExecFlow::PathNode source,
  RemoteUserInputToArgumentToExecFlow::PathNode sink, Expr execArg
where execIsTainted(source, sink, execArg)
select execArg, source, sink, "This command line depends on a $@.", source.getNode(),
  "user-provided value"
