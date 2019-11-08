/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * command-injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import go

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

  /**
   * A sanitizer guard for command-injection vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /** A source of untrusted data, considered as a taint source for command injection. */
  class UntrustedFlowAsSource extends Source {
    UntrustedFlowAsSource() { this instanceof UntrustedFlowSource }
  }

  /** A command name, considered as a taint sink for command injection. */
  class CommandNameAsSink extends Sink {
    CommandNameAsSink() { this = any(SystemCommandExecution exec).getCommandName() }
  }
}
