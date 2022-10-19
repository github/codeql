/**
 * Provides default sources and sinks for reasoning about sensitive data sourced
 * from the query string of a GET request, as well as extension points for
 * adding your own.
 */

private import codeql.ruby.security.SensitiveActions
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow

/**
 * Provides default sources and sinks for reasoning about sensitive data sourced
 * from the query string of a GET request, as well as extension points for
 * adding your own.
 */
module SensitiveGetQuery {
  /**
   * A data flow source representing data sourced from the query string in a
   * GET request handler.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets the request handler corresponding to this data source. */
    abstract Http::Server::RequestHandler getHandler();
  }

  /**
   * An access to data from the query string of a GET request as a data flow
   * source.
   */
  private class RequestInputAccessSource extends Source instanceof Http::Server::RequestInputAccess {
    private Http::Server::RequestHandler handler;

    RequestInputAccessSource() {
      handler = this.asExpr().getExpr().getEnclosingMethod() and
      handler.getAnHttpMethod() = "get" and
      this.getKind() = "parameter"
    }

    override Http::Server::RequestHandler getHandler() { result = handler }
  }

  /**
   * A data flow sink suggesting a use of sensitive data.
   */
  abstract class Sink extends DataFlow::Node { }

  /** A sensitive data node as a data flow sink. */
  private class SensitiveNodeSink extends Sink instanceof SensitiveNode {
    SensitiveNodeSink() {
      // User names and other similar information is not sensitive in this context.
      not this.getClassification() = SensitiveDataClassification::id()
    }
  }
}
