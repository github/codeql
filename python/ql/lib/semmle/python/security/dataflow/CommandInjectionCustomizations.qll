/**
 * Provides default sources, sinks and sanitizers for detecting
 * "command injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "command injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module CommandInjection {
  /**
   * A data flow source for "command injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "command injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "command injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for "command injection" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A command execution, considered as a flow sink.
   */
  class CommandExecutionAsSink extends Sink {
    CommandExecutionAsSink() {
      this = any(SystemCommandExecution e).getCommand() and
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
      not this.getScope().getEnclosingModule().getName() in [
          "os", "subprocess", "platform", "popen2"
        ]
    }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends SanitizerGuard, StringConstCompare { }
}
