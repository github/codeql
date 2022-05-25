/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * cleartext logging of sensitive information, as well as extension points for
 * adding your own.
 */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts
private import internal.CleartextSources

/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * cleartext logging of sensitive information, as well as extension points for
 * adding your own.
 */
module CleartextLogging {
  /**
   * A data flow source for cleartext logging of sensitive information.
   */
  class Source = CleartextSources::Source;

  /**
   * A sanitizer for cleartext logging of sensitive information.
   */
  class Sanitizer = CleartextSources::Sanitizer;

  /** Holds if `nodeFrom` taints `nodeTo`. */
  predicate isAdditionalTaintStep = CleartextSources::isAdditionalTaintStep/2;

  /**
   * A data flow sink for cleartext logging of sensitive information.
   */
  abstract class Sink extends DataFlow::Node { }

  private string commonLogMethodName() {
    result = ["info", "debug", "warn", "warning", "error", "log"]
  }

  /**
   * A node representing an expression whose value is logged.
   */
  private class LoggingInputAsSink extends Sink {
    LoggingInputAsSink() {
      // precise match based on inferred type of receiver
      exists(Logging logging | this = logging.getAnInput())
      or
      // imprecise name based match
      exists(DataFlow::CallNode call, string recvName |
        recvName =
          call.getReceiver().asExpr().getExpr().(VariableReadAccess).getVariable().getName() and
        recvName.regexpMatch(".*log(ger)?") and
        call.getMethodName() = commonLogMethodName()
      |
        this = call.getArgument(_)
      )
    }
  }
}
