/**
 * Provides classes and predicates used by the XSS queries.
 */

import go

/** Provides classes and predicates shared between the XSS queries. */
module SharedXss {
  /** A data flow sink for XSS vulnerabilities. */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the kind of vulnerability to report in the alert message.
     *
     * Defaults to `Cross-site scripting`, but may be overridden for sinks
     * that do not allow script injection, but injection of other undesirable HTML elements.
     */
    string getVulnerabilityKind() { result = "Cross-site scripting" }

    /**
     * Gets the kind of sink
     */
    string getSinkKind() { none() }

    /** Gets an associated locatable, if any. */
    Locatable getAssociatedLoc() { result = this.getFile() }
  }

  /** A sanitizer for XSS vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * An expression that is sent as part of an HTTP response body, considered as an
   * XSS sink.
   *
   * We exclude cases where the route handler sets either an unknown content type or
   * a content type that does not (case-insensitively) contain the string "html". This
   * is to prevent us from flagging plain-text or JSON responses as vulnerable.
   */
  class HttpResponseBodySink extends Sink, Http::ResponseBody {
    HttpResponseBodySink() { not nonHtmlContentType(this) }
  }

  /**
   * An expression that is rendered as part of a template.
   */
  class RawTemplateInstantiationSink extends HttpResponseBodySink, Http::TemplateResponseBody {
    override string getSinkKind() { result = "rawtemplate" }

    override Locatable getAssociatedLoc() { result = this.getRead().getEnclosingTextNode() }
  }

  private class DefaultSink extends Sink {
    DefaultSink() { sinkNode(this, ["html-injection", "js-injection"]) }
  }

  /**
   * Holds if `body` may send a response with a content type other than HTML.
   */
  private predicate nonHtmlContentType(Http::ResponseBody body) {
    not htmlTypeSpecified(body) and
    (
      exists(body.getAContentType())
      or
      exists(body.getAContentTypeNode())
      or
      exists(DataFlow::CallNode call | call.getTarget().hasQualifiedName("fmt", "Fprintf") |
        body = call.getASyntacticArgument() and
        // checks that the format value does not start with (ignoring whitespace as defined by
        // https://mimesniff.spec.whatwg.org/#whitespace-byte):
        //  - '<', which could lead to an HTML content type being detected, or
        //  - '%', which could be a format string.
        call.getSyntacticArgument(1).getStringValue().regexpMatch("(?s)[\\t\\n\\x0c\\r ]*+[^<%].*")
      )
      or
      exists(DataFlow::Node pred | body = pred.getASuccessor*() |
        // data starting with a character other than `<` (ignoring whitespace as defined by
        // https://mimesniff.spec.whatwg.org/#whitespace-byte) cannot cause an HTML content type to
        // be detected.
        pred.getStringValue().regexpMatch("(?s)[\\t\\n\\x0c\\r ]*+[^<].*")
      )
    )
  }

  /**
   * Holds if `body` specifies the response's content type to be HTML.
   */
  private predicate htmlTypeSpecified(Http::ResponseBody body) {
    body.getAContentType().regexpMatch("(?i).*html.*")
  }

  /**
   * A JSON marshaler, acting to sanitize a possible XSS vulnerability because the
   * marshaled value is very unlikely to be returned as an HTML content-type.
   */
  class JsonMarshalSanitizer extends Sanitizer {
    JsonMarshalSanitizer() {
      exists(MarshalingFunction mf | mf.getFormat() = "JSON" |
        this = mf.getOutput().getNode(mf.getACall())
      )
    }
  }

  /**
   * A http.Error function returns with the ContentType of text/plain, and is not a valid XSS sink
   */
  class ErrorSanitizer extends Sanitizer {
    ErrorSanitizer() {
      exists(Function f, DataFlow::CallNode call | call = f.getACall() |
        f.hasQualifiedName("net/http", "Error") and
        call.getArgument(1) = this
      )
    }
  }

  /**
   * A regexp replacement involving an HTML meta-character, or a call to an escape
   * function, viewed as a sanitizer for XSS vulnerabilities.
   *
   * The XSS queries do not attempt to reason about correctness or completeness of sanitizers,
   * so any such call stops taint propagation.
   */
  class MetacharEscapeSanitizer extends Sanitizer, DataFlow::CallNode {
    MetacharEscapeSanitizer() {
      exists(Function f | f = this.getCall().getTarget() |
        f.(RegexpReplaceFunction).getRegexp(this).getPattern().regexpMatch(".*['\"&<>].*")
        or
        f instanceof HtmlEscapeFunction
        or
        f instanceof JsEscapeFunction
      )
    }
  }

  /**
   * A `Template` from `html/template` will HTML-escape data automatically
   * and therefore acts as a sanitizer for XSS vulnerabilities.
   */
  class HtmlTemplateSanitizer extends Sanitizer, DataFlow::Node {
    HtmlTemplateSanitizer() {
      exists(Method m, DataFlow::CallNode call | m = call.getCall().getTarget() |
        m.hasQualifiedName("html/template", "Template", "ExecuteTemplate") and
        call.getArgument(2) = this
        or
        m.hasQualifiedName("html/template", "Template", "Execute") and
        call.getArgument(1) = this
      )
    }
  }
}
