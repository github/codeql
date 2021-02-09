/**
 * Provides classes for modelling the server-side form/file parsing libraries.
 */

import javascript

/**
 * Classes and predicate modelling the `Busboy` library.
 */
private module Busboy {
  /**
   * A `Busboy` instance that has request data flowing into it.
   */
  private DataFlow::NewNode busboy() {
    result = DataFlow::moduleImport("busboy").getAnInstantiation() and
    exists(MethodCallExpr pipe |
      pipe.calls(any(HTTP::RequestExpr req), "pipe") and
      result.flowsToExpr(pipe.getArgument(0))
    )
  }

  /**
   * A source of remote flow from the `Busboy` library.
   */
  class BusBoyRemoteFlow extends RemoteFlowSource {
    BusBoyRemoteFlow() { this = busboy().getAMemberCall("on").getABoundCallbackParameter(1, _) }

    override string getSourceType() { result = "Busbuy parsed user value" }
  }
}

/**
 * A source of remote flow from the `Formidable` library parsing a HTTP request.
 */
private class FormidableRemoteFlow extends RemoteFlowSource {
  FormidableRemoteFlow() {
    exists(DataFlow::CallNode parse, DataFlow::InvokeNode formidable |
      formidable = DataFlow::moduleImport("formidable").getACall()
      or
      formidable = DataFlow::moduleMember("formidable", "formidable").getACall()
      or
      formidable =
        DataFlow::moduleMember("formidable", ["IncomingForm", "Formidable"]).getAnInstantiation()
    |
      parse = formidable.getAMemberCall("parse") and
      parse.getArgument(0).asExpr() instanceof HTTP::RequestExpr and
      this = parse.getABoundCallbackParameter(1, any(int i | i > 0))
    )
  }

  override string getSourceType() { result = "Formidable parsed user value" }
}
