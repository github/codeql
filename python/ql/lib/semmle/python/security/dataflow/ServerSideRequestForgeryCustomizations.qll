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
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the request this sink belongs to.
     */
    abstract HTTP::Client::Request getRequest();
  }

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
    HTTP::Client::Request req;

    HttpRequestUrlAsSink() {
      req.getAUrlPart() = this and
      // if we extract the stdlib code for HTTPConnection, we will also find calls that
      // make requests within the HTTPConnection implementation -- for example the
      // `request` method calls the `_send_request` method internally. So without this
      // extra bit of code, we would give alerts within the HTTPConnection
      // implementation as well, which is just annoying.
      //
      // Notice that we're excluding based on the request location, and not the URL part
      // location, since the URL part would be in user code for the scenario above.
      //
      // See comment for command injection sinks for more details.
      not req.getScope().getEnclosingModule().getName() in ["http.client", "httplib"]
    }

    override HTTP::Client::Request getRequest() { result = req }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends SanitizerGuard, StringConstCompare { }

  /**
   * A string construction (concat, format, f-string) where the left side is not
   * user-controlled.
   *
   * For all of these cases, we try to allow `http://` or `https://` on the left side
   * since that will still allow full URL control.
   */
  class StringConstructionAsFullUrlControlSanitizer extends FullUrlControlSanitizer {
    StringConstructionAsFullUrlControlSanitizer() {
      // string concat
      exists(BinaryExprNode add |
        add.getOp() instanceof Add and
        add.getRight() = this.asCfgNode() and
        not add.getLeft().getNode().(StrConst).getText().toLowerCase() in ["http://", "https://"]
      )
      or
      // % formatting
      exists(BinaryExprNode fmt |
        fmt.getOp() instanceof Mod and
        fmt.getRight() = this.asCfgNode() and
        // detecting %-formatting is not super easy, so we simplify it to only handle
        // when there is a **single** substitution going on.
        not fmt.getLeft().getNode().(StrConst).getText().regexpMatch("^(?i)https?://%s[^%]*$")
      )
      or
      // arguments to a format call
      exists(DataFlow::MethodCallNode call, string httpPrefixRe |
        httpPrefixRe = "^(?i)https?://(?:(\\{\\})|\\{([0-9]+)\\}|\\{([^0-9].*)\\}).*$"
      |
        call.getMethodName() = "format" and
        (
          if call.getObject().asExpr().(StrConst).getText().regexpMatch(httpPrefixRe)
          then
            exists(string text | text = call.getObject().asExpr().(StrConst).getText() |
              // `http://{}...`
              exists(text.regexpCapture(httpPrefixRe, 1)) and
              this in [call.getArg(any(int i | i >= 1)), call.getArgByName(_)]
              or
              // `http://{123}...`
              exists(int safeArgIndex | safeArgIndex = text.regexpCapture(httpPrefixRe, 2).toInt() |
                this in [call.getArg(any(int i | i != safeArgIndex)), call.getArgByName(_)]
              )
              or
              // `http://{abc}...`
              exists(string safeArgName | safeArgName = text.regexpCapture(httpPrefixRe, 3) |
                this in [call.getArg(_), call.getArgByName(any(string s | s != safeArgName))]
              )
            )
          else this in [call.getArg(_), call.getArgByName(_)]
        )
      )
      or
      // f-string
      exists(Fstring fstring |
        if fstring.getValue(0).(StrConst).getText().toLowerCase() in ["http://", "https://"]
        then fstring.getValue(any(int i | i >= 2)) = this.asExpr()
        else fstring.getValue(any(int i | i >= 1)) = this.asExpr()
      )
    }
  }
}
