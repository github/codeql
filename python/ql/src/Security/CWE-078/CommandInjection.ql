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
    sink = any(SystemCommandExecution e).getCommand() and
    // Since the implementation of standard library functions such `os.popen` looks like
    // ```py
    // def popen(cmd, mode="r", buffering=-1):
    //     ...
    //     proc = subprocess.Popen(cmd, ...)
    // ```
    // any time we would report flow to the `os.popen` sink, we can ALSO report the flow
    // from the `cmd` parameter to the `subprocess.Popen` sink -- obviously we don't
    // want that.
    //
    // However, simply removing taint edges out of a sink is not a good enough solution,
    // since we would only flag one of the `os.system` calls in the following example
    // due to use-use flow
    // ```py
    // os.system(cmd)
    // os.system(cmd)
    // ```
    //
    // Best solution I could come up with is to exclude all sinks inside the modules of
    // known sinks. This does have a downside: If we have overlooked a function in any
    // of these, that internally runs a command, we no longer give an alert :| -- and we
    // need to keep them updated (which is hard to remember)
    //
    // This does not only affect `os.popen`, but also the helper functions in
    // `subprocess`. See:
    // https://github.com/python/cpython/blob/fa7ce080175f65d678a7d5756c94f82887fc9803/Lib/os.py#L974
    // https://github.com/python/cpython/blob/fa7ce080175f65d678a7d5756c94f82887fc9803/Lib/subprocess.py#L341
    not sink.getScope().getEnclosingModule().getName() in ["os", "subprocess", "platform", "popen2"]
  }
}

from CommandInjectionConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This command depends on $@.", source.getNode(),
  "a user-provided value"
