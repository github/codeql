/**
 * Provides classes for modelling the server-side form/file parsing libraries.
 */

import javascript

/**
 * Classes and predicate modelling the `Busboy` library.
 */
module Busboy {
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
