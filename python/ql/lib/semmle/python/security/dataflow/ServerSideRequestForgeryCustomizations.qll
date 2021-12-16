/**
 * Provides default sources, sinks and sanitizers for detecting
 * "Server-side request forgery"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "Server-side request forgery"
 * vulnerabilities, as well as extension points for adding your own.
 */
module ServerSideRequestForgery {
  /**
   * A data flow source for "Server-side request forgery" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "Server-side request forgery" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "Server-side request forgery" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer for "Server-side request forgery" vulnerabilities,
   * that ensures the attacker does not have full control of the URL. (that is, might
   * still be able to control path or query parameters).
   */
  abstract class FullUrlControlSanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for "Server-side request forgery" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /** The URL of an HTTP request, considered as a sink. */
  class HttpRequestUrlAsSink extends Sink {
    HttpRequestUrlAsSink() {
      exists(HTTP::Client::Request req | req.getAUrlPart() = this) and
      // Since we find sinks inside stdlib, we need to exclude them manually. See
      // comment for command injection sinks for more details.
      not this.getScope().getEnclosingModule().getName() in ["http.client", "httplib"]
    }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends SanitizerGuard, StringConstCompare { }

  /**
   * A string construction (concat, format, f-string) where the left side is not
   * user-controlled.
   */
  class StringConstructioneAsFullUrlControlSanitizer extends FullUrlControlSanitizer {
    StringConstructioneAsFullUrlControlSanitizer() {
      // string concat
      exists(BinaryExprNode add |
        add.getOp() instanceof Add and
        add.getRight() = this.asCfgNode()
      )
      or
      // % formatting
      exists(BinaryExprNode fmt |
        fmt.getOp() instanceof Mod and
        fmt.getRight() = this.asCfgNode()
      )
      or
      // arguments to a format call
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = "format" and
        this in [call.getArg(_), call.getArgByName(_)]
      )
      or
      // f-string
      exists(Fstring fstring | fstring.getValue(any(int i | i > 0)) = this.asExpr())
    }
  }
}
