/**
 * @name Uncontrolled command line from stored user input
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision medium
 * @id cs/stored-command-line-injection
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import csharp
import semmle.code.csharp.security.dataflow.flowsources.Stored
import semmle.code.csharp.security.dataflow.CommandInjectionQuery
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

class StoredTaintTrackingConfiguration extends TaintTrackingConfiguration {
  override predicate isSource(DataFlow::Node source) { source instanceof StoredFlowSource }
}

from StoredTaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used in a command.", source.getNode(),
  "Stored user-provided value"
