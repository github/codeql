/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * command-injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript

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

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source instanceof ActiveThreatModelSource {
    ActiveThreatModelSourceAsSource() { not this.isClientSideSource() }

    override string getSourceType() { result = "a user-provided value" }
  }

  /**
   * A response from a server, considered as a flow source for command injection.
   */
  class ServerResponse extends Source {
    ServerResponse() { this = any(ClientRequest r).getAResponseDataNode() }

    override string getSourceType() { result = "a server-provided value" }
  }

  /**
   * A command argument to a function that initiates an operating system command.
   */
  class SystemCommandExecutionSink extends Sink, DataFlow::ValueNode {
    SystemCommandExecutionSink() { this = any(SystemCommandExecution sys).getACommandArgument() }
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() { this = ModelOutput::getASinkNode("command-injection").asSink() }
  }
}
