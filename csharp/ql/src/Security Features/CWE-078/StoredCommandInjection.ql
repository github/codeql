/**
 * @name Uncontrolled command line from stored user input
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/stored-command-line-injection
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import csharp
import semmle.code.csharp.security.dataflow.flowsources.Stored
import semmle.code.csharp.security.dataflow.CommandInjection::CommandInjection

class StoredTaintTrackingConfiguration extends TaintTrackingConfiguration {
  override predicate isSource(DataFlow::Node source) {
    source instanceof StoredFlowSource
  }
}

from StoredTaintTrackingConfiguration c, StoredFlowSource source, Sink sink
where c.hasFlow(source, sink)
select sink, "$@ flows to here and is used in a command.", source, "Stored user-provided value"
