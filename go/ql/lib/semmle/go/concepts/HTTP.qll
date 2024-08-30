/**
 * Provides classes for working with HTTP-related concepts such as requests and responses.
 */

import go

/** Provides classes for modeling HTTP-related APIs. */
module Http {
  /** Provides a class for modeling new HTTP response-writer APIs. */
  module ResponseWriter {
    /**
     * A variable that is an HTTP response writer.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `HTTP::ResponseWriter` instead.
     */
    abstract class Range extends Variable {
      /**
       * Gets a data-flow node that is a use of this response writer.
       *
       * Note that `PostUpdateNode`s for nodes that this predicate gets do not need to be
       * included, as they are handled by the concrete `ResponseWriter`'s `getANode`.
       */
      abstract DataFlow::Node getANode();
    }
  }

  /**
   * A variable that is an HTTP response writer.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `HTTP::ResponseWriter::Range` instead.
   */
  class ResponseWriter extends Variable instanceof ResponseWriter::Range {
    /** Gets the body that is written in this HTTP response. */
    ResponseBody getBody() { result.getResponseWriter() = this }

    /** Gets a header write that is written in this HTTP response. */
    HeaderWrite getAHeaderWrite() { result.getResponseWriter() = this }

    /** Gets a redirect that is sent in this HTTP response. */
    Redirect getARedirect() { result.getResponseWriter() = this }

    /** Gets a data-flow node that is a use of this response writer. */
    DataFlow::Node getANode() {
      result = super.getANode() or
      result.(DataFlow::PostUpdateNode).getPreUpdateNode() = super.getANode()
    }
  }

  /** Provides a class for modeling new HTTP header-write APIs. */
  module HeaderWrite {
    /**
     * A data-flow node that represents a write to an HTTP header.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `HTTP::HeaderWrite` instead.
     */
    abstract class Range extends DataFlow::ExprNode {
      /** Gets the (lower-case) name of a header set by this definition. */
      string getHeaderName() { result = this.getName().getStringValue().toLowerCase() }

      /** Gets the value of the header set by this definition. */
      string getHeaderValue() {
        result = this.getValue().getStringValue()
        or
        result = this.getValue().getIntValue().toString()
      }

      /** Holds if this header write defines the header `header`. */
      predicate definesHeader(string header, string value) {
        header = this.getHeaderName() and
        value = this.getHeaderValue()
      }

      /**
       * Gets the node representing the name of the header defined by this write.
       *
       * Note that a `HeaderWrite` targeting a constant header (e.g. a routine that always
       * sets the `Content-Type` header) may not have such a node, so callers should use
       * `getHeaderName` in preference to this method).
       */
      abstract DataFlow::Node getName();

      /** Gets the node representing the value of the header defined by this write. */
      abstract DataFlow::Node getValue();

      /** Gets the response writer associated with this header write, if any. */
      abstract ResponseWriter getResponseWriter();
    }
  }

  /**
   * A data-flow node that represents a write to an HTTP header.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `HTTP::HeaderWrite::Range` instead.
   */
  class HeaderWrite extends DataFlow::ExprNode instanceof HeaderWrite::Range {
    /** Gets the (lower-case) name of a header set by this definition. */
    string getHeaderName() { result = super.getHeaderName() }

    /** Gets the value of the header set by this definition. */
    string getHeaderValue() { result = super.getHeaderValue() }

    /** Holds if this header write defines the header `header`. */
    predicate definesHeader(string header, string value) { super.definesHeader(header, value) }

    /**
     * Gets the node representing the name of the header defined by this write.
     *
     * Note that a `HeaderWrite` targeting a constant header (e.g. a routine that always
     * sets the `Content-Type` header) may not have such a node, so callers should use
     * `getHeaderName` in preference to this method).
     */
    DataFlow::Node getName() { result = super.getName() }

    /** Gets the node representing the value of the header defined by this write. */
    DataFlow::Node getValue() { result = super.getValue() }

    /** Gets the response writer associated with this header write, if any. */
    ResponseWriter getResponseWriter() { result = super.getResponseWriter() }
  }

  /** A data-flow node whose value is written to an HTTP header. */
  class Header extends DataFlow::Node {
    HeaderWrite hw;

    Header() {
      this = hw.getName()
      or
      this = hw.getValue()
    }

    /** Gets the response writer associated with this header write, if any. */
    ResponseWriter getResponseWriter() { result = hw.getResponseWriter() }
  }

  /** A data-flow node whose value is written to the value of an HTTP header. */
  class HeaderValue extends Header {
    HeaderValue() { this = hw.getValue() }
  }

  /** A data-flow node whose value is written to the name of an HTTP header. */
  class HeaderName extends Header {
    HeaderName() { this = hw.getName() }
  }

  /** Provides a class for modeling new HTTP request-body APIs. */
  module RequestBody {
    /**
     * An expression representing a reader whose content is written to an HTTP request body.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `HTTP::RequestBody` instead.
     */
    abstract class Range extends DataFlow::Node { }
  }

  /**
   * An expression representing a reader whose content is written to an HTTP request body.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `HTTP::RequestBody::Range` instead.
   */
  class RequestBody extends DataFlow::Node instanceof RequestBody::Range { }

  /** Provides a class for modeling new HTTP response-body APIs. */
  module ResponseBody {
    /**
     * An expression which is written to an HTTP response body.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `HTTP::ResponseBody` instead.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets the response writer associated with this header write, if any. */
      abstract ResponseWriter getResponseWriter();

      /** Gets a content-type associated with this body. */
      string getAContentType() {
        exists(Http::HeaderWrite hw | hw = this.getResponseWriter().getAHeaderWrite() |
          hw.getHeaderName() = "content-type" and
          result = hw.getHeaderValue()
        )
        or
        result = this.getAContentTypeNode().getStringValue()
      }

      /** Gets a dataflow node for a content-type associated with this body. */
      DataFlow::Node getAContentTypeNode() {
        exists(Http::HeaderWrite hw | hw = this.getResponseWriter().getAHeaderWrite() |
          hw.getHeaderName() = "content-type" and
          result = hw.getValue()
        )
      }
    }
  }

  /**
   * An expression which is written to an HTTP response body.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `HTTP::ResponseBody::Range` instead.
   */
  class ResponseBody extends DataFlow::Node instanceof ResponseBody::Range {
    /** Gets the response writer associated with this header write, if any. */
    ResponseWriter getResponseWriter() { result = super.getResponseWriter() }

    /** Gets a content-type associated with this body. */
    string getAContentType() { result = super.getAContentType() }

    /** Gets a dataflow node for a content-type associated with this body. */
    DataFlow::Node getAContentTypeNode() { result = super.getAContentTypeNode() }
  }

  /** Provides a class for modeling new HTTP template response-body APIs. */
  module TemplateResponseBody {
    /**
     * An expression which is written to an HTTP response body via a template execution.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `HTTP::ResponseBody` instead.
     */
    abstract class Range extends ResponseBody::Range {
      /** Gets the read of the variable inside the template where this value is read. */
      abstract HtmlTemplate::TemplateRead getRead();
    }
  }

  /**
   * An expression which is written to an HTTP response body via a template execution.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `HTTP::TemplateResponseBody::Range` instead.
   */
  class TemplateResponseBody extends ResponseBody instanceof TemplateResponseBody::Range {
    /** Gets the read of the variable inside the template where this value is read. */
    HtmlTemplate::TemplateRead getRead() { result = super.getRead() }
  }

  /** Provides a class for modeling new HTTP client request APIs. */
  module ClientRequest {
    /**
     * A call that performs a request to a URL.
     *
     * Example: An HTTP POST request is a client request that sends some
     * `data` to a `url`, where both the headers and the body of the request
     * contribute to the `data`.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `HTTP::ClientRequest` instead.
     */
    abstract class Range extends DataFlow::Node {
      /**
       * Gets the URL of the request.
       */
      abstract DataFlow::Node getUrl();
    }
  }

  /**
   * A call that performs a request to a URL.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `HTTP::ClientRequest::Range` instead.
   */
  class ClientRequest extends DataFlow::Node instanceof ClientRequest::Range {
    /**
     * Gets the URL of the request.
     */
    DataFlow::Node getUrl() { result = super.getUrl() }
  }

  /** Provides a class for modeling new HTTP redirect APIs. */
  module Redirect {
    /**
     * An HTTP redirect.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `HTTP::Redirect` instead.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets the data-flow node representing the URL being redirected to. */
      abstract DataFlow::Node getUrl();

      /** Gets the response writer that this redirect is sent on, if any. */
      abstract ResponseWriter getResponseWriter();
    }

    /**
     * An assignment of the HTTP Location header, which indicates the location for a
     * redirect.
     */
    private class LocationHeaderSet extends Range, HeaderWrite {
      LocationHeaderSet() { this.getHeaderName() = "location" }

      override DataFlow::Node getUrl() { result = this.getValue() }

      override ResponseWriter getResponseWriter() { result = HeaderWrite.super.getResponseWriter() }
    }

    /**
     * An HTTP request attribute that is generally not attacker-controllable for
     * open redirect exploits; for example, a form field submitted in a POST request.
     */
    abstract class UnexploitableSource extends DataFlow::Node { }

    private predicate sinkKindInfo(string kind, int rw) {
      kind = "url-redirection" and
      rw = -2
      or
      kind = "url-redirection[receiver]" and
      rw = -1
      or
      sinkModel(_, _, _, _, _, _, _, kind, _, _) and
      exists(string rwStr |
        rwStr.toInt() = rw and
        kind = "url-redirection[" + rwStr + "]"
      )
    }

    private class DefaultHttpRedirect extends Range, DataFlow::CallNode {
      DataFlow::ArgumentNode url;
      int rw;

      DefaultHttpRedirect() {
        this = url.getCall() and
        exists(string kind |
          sinkKindInfo(kind, rw) and
          sinkNode(url, kind)
        )
      }

      override DataFlow::Node getUrl() { result = url.getACorrespondingSyntacticArgument() }

      override Http::ResponseWriter getResponseWriter() {
        rw = -1 and result.getANode() = this.getReceiver()
        or
        rw >= 0 and result.getANode() = this.getArgument(rw)
      }
    }
  }

  /**
   * An HTTP redirect.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `HTTP::Redirect::Range` instead.
   */
  class Redirect extends DataFlow::Node instanceof Redirect::Range {
    /** Gets the data-flow node representing the URL being redirected to. */
    DataFlow::Node getUrl() { result = super.getUrl() }

    /** Gets the response writer that this redirect is sent on, if any. */
    ResponseWriter getResponseWriter() { result = super.getResponseWriter() }
  }

  /** Provides a class for modeling new HTTP handler APIs. */
  module RequestHandler {
    /**
     * An HTTP request handler.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `HTTP::RequestHandler` instead.
     */
    abstract class Range extends DataFlow::Node {
      /** Gets a node that is used in a check that is tested before this handler is run. */
      abstract predicate guardedBy(DataFlow::Node check);
    }
  }

  /**
   * An HTTP request handler.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `HTTP::RequestHandler::Range` instead.
   */
  class RequestHandler extends DataFlow::Node instanceof RequestHandler::Range {
    /** Gets a node that is used in a check that is tested before this handler is run. */
    predicate guardedBy(DataFlow::Node check) { super.guardedBy(check) }
  }
}
