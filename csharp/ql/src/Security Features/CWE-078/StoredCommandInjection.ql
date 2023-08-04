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
import StoredCommandInjection::PathGraph

module StoredCommandInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof StoredFlowSource }

  predicate isSink = CommandInjectionConfig::isSink/1;

  predicate isBarrier = CommandInjectionConfig::isBarrier/1;
}

module StoredCommandInjection = TaintTracking::Global<StoredCommandInjectionConfig>;

from StoredCommandInjection::PathNode source, StoredCommandInjection::PathNode sink
where StoredCommandInjection::flowPath(source, sink)
select sink.getNode(), source, sink, "This command line depends on a $@.", source.getNode(),
  "stored (potentially user-provided) value"
