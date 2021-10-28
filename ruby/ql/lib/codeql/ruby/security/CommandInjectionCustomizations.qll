/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * command-injection vulnerabilities, as well as extension points for
 * adding your own.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.Concepts
private import codeql.ruby.Frameworks
private import codeql.ruby.ApiGraphs

module CommandInjection {
  /**
   * A data flow source for command-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this remote flow source. */
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

  /** A source of remote user input, considered as a flow source for command injection. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }

    override string getSourceType() { result = "a user-provided value" }
  }

  /**
   * A command argument to a function that initiates an operating system command.
   */
  class SystemCommandExecutionSink extends Sink {
    SystemCommandExecutionSink() { exists(SystemCommandExecution c | c.isShellInterpreted(this)) }
  }

  /**
   * A call to `Shellwords.escape` or `Shellwords.shellescape` sanitizes its input.
   */
  class ShellwordsEscapeAsSanitizer extends Sanitizer {
    ShellwordsEscapeAsSanitizer() {
      this = API::getTopLevelMember("Shellwords").getAMethodCall(["escape", "shellescape"])
    }
  }
}
