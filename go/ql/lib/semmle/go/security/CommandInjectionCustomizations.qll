/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * command-injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import go
private import semmle.go.dataflow.barrierguardutil.RegexpCheck

/**
 * Provides extension points for customizing the taint tracking configuration for reasoning about
 * command injection vulnerabilities.
 */
module CommandInjection {
  /**
   * A data flow source for command-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for command-injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /** Holds if this node is sanitized whenever it follows `--` in an argument list. */
    predicate doubleDashIsSanitizing() { none() }
  }

  /**
   * A sanitizer for command-injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * DEPRECATED: Use `ThreatModelFlowSource` or `Source` instead.
   */
  deprecated class UntrustedFlowAsSource = ThreatModelFlowAsSource;

  /** A source of untrusted data, considered as a taint source for command injection. */
  private class ThreatModelFlowAsSource extends Source instanceof ThreatModelFlowSource { }

  /** A command name, considered as a taint sink for command injection. */
  class CommandNameAsSink extends Sink {
    SystemCommandExecution exec;

    CommandNameAsSink() { this = exec.getCommandName() }

    override predicate doubleDashIsSanitizing() { exec.doubleDashIsSanitizing() }
  }

  /**
   * A call to a regexp match function, considered as a barrier guard for command injection.
   */
  class RegexpCheckBarrierAsSanitizer extends Sanitizer instanceof RegexpCheckBarrier { }

  private predicate noDoubleDashPrefixCheck(DataFlow::Node hasPrefixNode, Expr e, boolean branch) {
    exists(StringOps::HasPrefix hasPrefix | hasPrefix = hasPrefixNode |
      e = hasPrefix.getBaseString().asExpr() and
      hasPrefix.getSubstring().asExpr().getStringValue() = "--" and
      branch = false
    )
  }

  /**
   * A call that confirms that the string does not start with `--`, considered as a barrier guard for command injection.
   */
  class NoDoubleDashPrefixSanitizer extends Sanitizer {
    NoDoubleDashPrefixSanitizer() {
      this = DataFlow::BarrierGuard<noDoubleDashPrefixCheck/3>::getABarrierNode()
    }
  }
}
