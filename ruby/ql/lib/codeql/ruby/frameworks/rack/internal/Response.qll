/**
 * Provides modeling for the `Response` component of the `Rack` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.controlflow.CfgNodes::ExprNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.typetracking.TypeTracking
private import App as A

/** Contains implementation details for modeling `Rack::Response`. */
module Private {
  /** A `DataFlow::Node` that may be a rack response. This is detected heuristically, if something "looks like" a rack response syntactically then we consider it to be a potential response node. */
  abstract class PotentialResponseNode extends DataFlow::Node {
    /** Gets the headers returned with this response. */
    abstract DataFlow::Node getHeaders();

    /** Gets the body of this response. */
    abstract DataFlow::Node getBody();
  }

  /** A rack response constructed directly using an array literal. */
  private class PotentialArrayResponse extends PotentialResponseNode, DataFlow::ArrayLiteralNode {
    // [status, headers, body]
    PotentialArrayResponse() { this.getNumberOfArguments() = 3 }

    override DataFlow::Node getHeaders() { result = this.getElement(1) }

    override DataFlow::Node getBody() { result = this.getElement(2) }
  }

  /** A rack response constructed by calling `finish` on an instance of `Rack::Response`. */
  private class RackResponseConstruction extends PotentialResponseNode, DataFlow::CallNode {
    private DataFlow::CallNode responseConstruction;

    // (body, status, headers)
    RackResponseConstruction() {
      responseConstruction =
        API::getTopLevelMember("Rack").getMember("Response").getAnInstantiation() and
      this = responseConstruction.getAMethodCall() and
      this.getMethodName() = "finish"
    }

    override DataFlow::Node getHeaders() { result = responseConstruction.getArgument(2) }

    override DataFlow::Node getBody() { result = responseConstruction.getArgument(0) }
  }
}

/**
 * Provides modeling for the `Response` component of the `Rack` library.
 */
module Public {
  bindingset[headerName]
  private DataFlow::Node getHeaderValue(ResponseNode resp, string headerName) {
    exists(DataFlow::Node headers | headers = resp.getHeaders() |
      // set via `headers.<header_name>=`
      exists(
        DataFlow::CallNode contentTypeAssignment, Assignment assignment,
        DataFlow::PostUpdateNode postUpdateHeaders
      |
        contentTypeAssignment.getMethodName() = headerName.replaceAll("-", "_").toLowerCase() + "=" and
        assignment =
          contentTypeAssignment.getArgument(0).(DataFlow::OperationNode).asOperationAstNode() and
        postUpdateHeaders.(DataFlow::LocalSourceNode).flowsTo(headers) and
        postUpdateHeaders.getPreUpdateNode() = contentTypeAssignment.getReceiver()
      |
        result.asExpr().getExpr() = assignment.getRightOperand()
      )
      or
      // set within a hash
      exists(DataFlow::HashLiteralNode headersHash | headersHash.flowsTo(headers) |
        result =
          headersHash
              .getElementFromKey(any(ConstantValue v |
                  v.getStringlikeValue().toLowerCase() = headerName.toLowerCase()
                ))
      )
      or
      // pair in a `Rack::Response.new` constructor
      exists(DataFlow::PairNode headerPair | headerPair = headers |
        headerPair.getKey().getConstantValue().getStringlikeValue().toLowerCase() =
          headerName.toLowerCase() and
        result = headerPair.getValue()
      )
    )
  }

  /** A `DataFlow::Node` returned from a rack request. */
  class ResponseNode extends Http::Server::HttpResponse::Range instanceof Private::PotentialResponseNode
  {
    ResponseNode() { this = any(A::App::RequestHandler handler).getAResponse() }

    override DataFlow::Node getBody() { result = this.(Private::PotentialResponseNode).getBody() }

    override DataFlow::Node getMimetypeOrContentTypeArg() {
      result = getHeaderValue(this, "content-type")
    }

    /** Gets the headers returned with this response. */
    DataFlow::Node getHeaders() { result = this.(Private::PotentialResponseNode).getHeaders() }

    // TODO: is there a sensible value for this?
    override string getMimetypeDefault() { none() }
  }

  /** A `DataFlow::Node` returned from a rack request that has a redirect HTTP status code. */
  class RedirectResponse extends ResponseNode, Http::Server::HttpRedirectResponse::Range {
    private DataFlow::Node redirectLocation;

    RedirectResponse() { redirectLocation = getHeaderValue(this, "location") }

    override DataFlow::Node getRedirectLocation() { result = redirectLocation }
  }
}
