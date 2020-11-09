/**
 * Provides a taint-tracking configuration for detecting command injection
 * vulnerabilities.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.Concepts
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A taint-tracking configuration for detecting command injection vulnerabilities.
 */
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
