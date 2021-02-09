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

    override string getSourceType() { result = "parsed user value from Busbuy" }
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

  override string getSourceType() { result = "parsed user value from Formidable" }
}

/**
 * Predicates and classes modelling the `multiparty` library.
 */
private module Multiparty {
  /**
   * Gets an instance of of `Multiparty` form parser that parses a HTTP request object.
   * The `parse` call is the method call that receives the HTTP request object.
   */
  private DataFlow::SourceNode form(DataFlow::MethodCallNode parse) {
    result = DataFlow::moduleMember("multiparty", "Form").getAnInstantiation() and
    parse = result.getAMethodCall("parse") and
    parse.getArgument(0).asExpr() instanceof HTTP::RequestExpr
  }

  /**
   * A source of remote flow from the `Multiparty` library.
   */
  class MultipartyRemoteFlow extends RemoteFlowSource {
    MultipartyRemoteFlow() {
      exists(DataFlow::MethodCallNode parse | exists(form(parse)) |
        this = parse.getABoundCallbackParameter(1, any(int i | i > 0))
      )
      or
      exists(DataFlow::MethodCallNode on | on = form(_).getAMethodCall("on") |
        on.getArgument(0).mayHaveStringValue(["part", "file", "field"]) and
        this = on.getABoundCallbackParameter(1, _)
      )
    }

    override string getSourceType() { result = "parsed user value from Multiparty" }
  }
}
