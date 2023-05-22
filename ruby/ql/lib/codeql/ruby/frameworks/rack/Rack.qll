/**
 * Provides modeling for the Rack library.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.controlflow.CfgNodes::ExprNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.typetracking.TypeTracker
private import internal.MimeTypes

/**
 * A class that may be a rack application.
 * This is a class that has a `call` method that takes a single argument
 * (traditionally called `env`) and returns a rack-compatible response.
 */
class AppCandidate extends DataFlow::ClassNode {
  private DataFlow::MethodNode call;
  private PotentialResponseNode resp;

  AppCandidate() {
    call = this.getInstanceMethod("call") and
    call.getNumberOfParameters() = 1 and
    call.getReturn() = trackRackResponse(resp)
  }

  /**
   * Gets the environment of the request, which is the lone parameter to the `call` method.
   */
  DataFlow::ParameterNode getEnv() { result = call.getParameter(0) }

  /** Gets the response returned from the request. */
  PotentialResponseNode getResponse() { result = resp }
}

private DataFlow::LocalSourceNode trackInt(TypeTracker t, int i) {
  t.start() and
  result.getConstantValue().isInt(i)
  or
  exists(TypeTracker t2 | result = trackInt(t2, i).track(t2, t))
}

private DataFlow::Node trackInt(int i) { trackInt(TypeTracker::end(), i).flowsTo(result) }

private class PotentialResponseNode extends DataFlow::ArrayLiteralNode {
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

private DataFlow::LocalSourceNode trackRackResponse(TypeTracker t, PotentialResponseNode n) {
  t.start() and
  result = n
  or
  exists(TypeTracker t2 | result = trackRackResponse(t2, n).track(t2, t))
}

private DataFlow::Node trackRackResponse(PotentialResponseNode n) {
  trackRackResponse(TypeTracker::end(), n).flowsTo(result)
}

class MimetypeCall extends DataFlow::CallNode {
  MimetypeCall() {
    this = API::getTopLevelMember("Rack").getMember("Mime").getAMethodCall("mime_type")
  }

  private string getExtension() {
    result = this.getArgument(0).getConstantValue().getStringlikeValue()
  }

  string getMimeType() { mimeTypeMatches(this.getExtension(), result) }
}

/** A `DataFlow::Node` returned from a rack request. */
class ResponseNode extends PotentialResponseNode, Http::Server::HttpResponse::Range {
  ResponseNode() { this = any(AppCandidate app).getResponse() }

  override DataFlow::Node getBody() { result = this.getElement(2) }

  override DataFlow::Node getMimetypeOrContentTypeArg() {
    exists(DataFlow::Node headers | headers = this.getHeaders() |
      // set via `headers.content_type=`
      exists(
        DataFlow::CallNode contentTypeAssignment, Assignment assignment,
        DataFlow::PostUpdateNode postUpdateHeaders
      |
        contentTypeAssignment.getMethodName() = "content_type=" and
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
                  v.getStringlikeValue().toLowerCase() = "content-type"
                ))
      )
    )
  }

  // TODO
  override string getMimetypeDefault() { none() }
}
