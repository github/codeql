/**
 * Provides modeling for the `Response` component of the `Rack` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.controlflow.CfgNodes::ExprNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.typetracking.TypeTracker
private import App as A

/** Contains implementation details for modeling `Rack::Response`. */
module Private {
  private DataFlow::LocalSourceNode trackInt(TypeTracker t, int i) {
    t.start() and
    result.getConstantValue().isInt(i)
    or
    exists(TypeTracker t2 | result = trackInt(t2, i).track(t2, t))
  }

  private DataFlow::Node trackInt(int i) { trackInt(TypeTracker::end(), i).flowsTo(result) }

  /** A `DataFlow::Node` that may be a rack response. This is detected heuristically, if something "looks like" a rack response syntactically then we consider it to be a potential response node. */
  class PotentialResponseNode extends DataFlow::ArrayLiteralNode {
    // [status, headers, body]
    PotentialResponseNode() { this.getNumberOfArguments() = 3 }

    /**
     * Gets an HTTP status code that may be returned in this response.
     */
    int getAStatusCode() { this.getElement(0) = trackInt(result) }

    /** Gets the headers returned with this response. */
    DataFlow::Node getHeaders() { result = this.getElement(1) }

    /** Gets the body of this response. */
    DataFlow::Node getBody() { result = this.getElement(2) }
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
    )
  }

  /** A `DataFlow::Node` returned from a rack request. */
  class ResponseNode extends Private::PotentialResponseNode, Http::Server::HttpResponse::Range {
    ResponseNode() { this = any(A::App::AppCandidate app).getResponse() }

    override DataFlow::Node getBody() { result = this.getElement(2) }

    override DataFlow::Node getMimetypeOrContentTypeArg() {
      result = getHeaderValue(this, "content-type")
    }

    // TODO: is there a sensible value for this?
    override string getMimetypeDefault() { none() }
  }

  /** A `DataFlow::Node` returned from a rack request that has a redirect HTTP status code. */
  class RedirectResponse extends ResponseNode, Http::Server::HttpRedirectResponse::Range {
    RedirectResponse() { this.getAStatusCode() = [300, 301, 302, 303, 307, 308] }

    override DataFlow::Node getRedirectLocation() { result = getHeaderValue(this, "location") }
  }
}
