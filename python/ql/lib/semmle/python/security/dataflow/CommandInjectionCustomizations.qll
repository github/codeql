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
private import semmle.python.frameworks.data.ModelsAsData

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
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

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
      //
      // The same approach is used in the path-injection, cleartext-storage, and
      // cleartext-logging queries.
      not this.getScope().getEnclosingModule().getName() in [
          "os", "subprocess", "platform", "popen2"
        ]
    }
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() { this = ModelOutput::getASinkNode("command-injection").asSink() }
  }

  /**
   * A comparison with a constant, considered as a sanitizer-guard.
   */
  class ConstCompareAsSanitizerGuard extends Sanitizer, ConstCompareBarrier { }

  /** DEPRECATED: Use ConstCompareAsSanitizerGuard instead. */
  deprecated class StringConstCompareAsSanitizerGuard = ConstCompareAsSanitizerGuard;
}
