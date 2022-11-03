/**
 * Provides a model of the `micro` NPM package.
 */

private import javascript

private module Micro {
  private import DataFlow

  /**
   * A node that should be interpreted as a route handler, to use as starting
   * point for back-tracking.
   */
  Node microRouteHandlerSink() {
    result = moduleMember("micro", "run").getACall().getLastArgument()
    or
    result = moduleImport("micro").getACall().getArgument(0)
  }

  /** Gets a data flow node interpreted as a route handler. */
  private DataFlow::SourceNode microRouteHandler(DataFlow::TypeBackTracker t) {
    t.start() and
    result = microRouteHandlerSink().getALocalSource()
    or
    exists(DataFlow::TypeBackTracker t2 | result = microRouteHandler(t2).backtrack(t2, t))
    or
    exists(DataFlow::CallNode transformer |
      transformer = moduleImport("micro-compress").getACall()
      or
      transformer instanceof Bluebird::BluebirdCoroutineDefinition
    |
      microRouteHandler(t.continue()) = transformer and
      result = transformer.getArgument(0).getALocalSource()
    )
  }

  /** Gets a data flow node interpreted as a route handler. */
  DataFlow::SourceNode microRouteHandler() {
    result = microRouteHandler(DataFlow::TypeBackTracker::end())
  }

  /**
   * A function passed to `micro` or `micro.run`.
   */
  class MicroRouteHandler extends HTTP::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    MicroRouteHandler() { this = microRouteHandler().getAFunctionValue() }
  }

  class MicroRequestSource extends HTTP::Servers::RequestSource {
    MicroRouteHandler h;

    MicroRequestSource() { this = h.getParameter(0) }

    override HTTP::RouteHandler getRouteHandler() { result = h }
  }

  class MicroResponseSource extends HTTP::Servers::ResponseSource {
    MicroRouteHandler h;

    MicroResponseSource() { this = h.getParameter(1) }

    override HTTP::RouteHandler getRouteHandler() { result = h }
  }

  class MicroRequestExpr extends NodeJSLib::RequestExpr {
    override MicroRequestSource src;
  }

  class MicroReseponseExpr extends NodeJSLib::ResponseExpr {
    override MicroResponseSource src;
  }

  private HTTP::RouteHandler getRouteHandlerFromReqRes(DataFlow::Node node) {
    exists(HTTP::Servers::RequestSource src |
      src.ref().flowsTo(node) and
      result = src.getRouteHandler()
    )
    or
    exists(HTTP::Servers::ResponseSource src |
      src.ref().flowsTo(node) and
      result = src.getRouteHandler()
    )
  }

  class MicroBodyParserCall extends HTTP::RequestInputAccess, DataFlow::CallNode {
    string name;

    MicroBodyParserCall() {
      name = ["buffer", "text", "json"] and
      this = moduleMember("micro", name).getACall()
    }

    override string getKind() { result = "body" }

    override HTTP::RouteHandler getRouteHandler() {
      result = getRouteHandlerFromReqRes(getArgument(0))
    }

    override predicate isUserControlledObject() { name = "json" }
  }

  class MicroSendArgument extends HTTP::ResponseSendArgument {
    CallNode send;

    MicroSendArgument() {
      send = moduleMember("micro", ["send", "sendError"]).getACall() and
      this = send.getLastArgument().asExpr()
    }

    override HTTP::RouteHandler getRouteHandler() {
      result = getRouteHandlerFromReqRes(send.getArgument([0, 1]))
    }
  }
}
