/**
 * @name Uncontrolled command line
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @id py/command-line-injection
 * @tags correctness
 *       security
 *       external/owasp/owasp-a1
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import python
import experimental.dataflow.DataFlow
import experimental.dataflow.TaintTracking
import experimental.semmle.python.Concepts
import experimental.dataflow.RemoteFlowSources
import DataFlow::PathGraph

class CommandInjectionConfiguration extends TaintTracking::Configuration {
  CommandInjectionConfiguration() { this = "CommandInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(SystemCommandExecution e).getCommand()
  }

  // Since the implementation of os.popen looks like
  // ```py
  // def popen(cmd, mode="r", buffering=-1):
  //     ...
  //     proc = subprocess.Popen(cmd, ...)
  // ```
  // any time we would report flow to the `os.popen` sink, we can ALSO report the flow
  // from the `cmd` parameter to the `subprocess.Popen` sink -- obviously we don't want
  // that, so to prevent that we remove any taint edges out of a sink.
  override predicate isSanitizerOut(DataFlow::Node node) { isSink(node) }
}

from CommandInjectionConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This command depends on $@.", source.getNode(),
  "a user-provided value"
