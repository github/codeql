/**
 * Provides default sources, sinks and sanitisers for reasoning about
 * command-injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources

module CommandInjection {
  /**
   * A data flow source for command-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

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
  }

  /**
   * A command argument to a function that initiates an operating system command.
   */
  class SystemCommandExecutionSink extends Sink, DataFlow::ValueNode {
    SystemCommandExecutionSink() { this = any(SystemCommandExecution sys).getACommandArgument() }
  }

}
