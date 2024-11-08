/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * command-injection vulnerabilities, as well as extension points for
 * adding your own.
 */

private import semmle.code.powershell.dataflow.DataFlow
private import semmle.code.powershell.dataflow.flowsources.FlowSources
private import semmle.code.powershell.Cfg

module CommandInjection {
  /**
   * A data flow source for command-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this flow source. */
    abstract string getSourceType();
  }

  /**
   * A data flow sink for command-injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for command-injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of user input, considered as a flow source for command injection. */
  class FlowSourceAsSource extends Source instanceof SourceNode {
    override string getSourceType() { result = "user-provided value" }
  }

  /**
   * A command argument to a function that initiates an operating system command.
   */
  class SystemCommandExecutionSink extends Sink {
    SystemCommandExecutionSink() {
      // An argument to a call
      exists(DataFlow::CallNode call |
        call.getName() = "Invoke-Expression"
        or
        call instanceof DataFlow::CallOperatorNode
      |
        call.getAnArgument() = this
      )
      or
      // Or the call command itself in case it's a use of operator &.
      any(DataFlow::CallOperatorNode call).getCommand() = this
    }
  }

  private class ExternalCommandInjectionSink extends Sink {
    ExternalCommandInjectionSink() {
      this = ModelOutput::getASinkNode("command-injection").asSink()
    }
  }
}
