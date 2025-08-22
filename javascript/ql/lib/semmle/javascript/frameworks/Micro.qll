/**
 * Provides a model of the `micro` NPM package.
 */

private import javascript

private module Micro {
  private import DataFlow

  /**
   * Gets a node that should be interpreted as a route handler, to use as starting
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
  class MicroRouteHandler extends Http::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    MicroRouteHandler() { this = microRouteHandler().getAFunctionValue() }
  }

  class MicroRequestSource extends Http::Servers::RequestSource {
    MicroRouteHandler h;

    MicroRequestSource() { this = h.getParameter(0) }

    override Http::RouteHandler getRouteHandler() { result = h }
  }

  class MicroResponseSource extends Http::Servers::ResponseSource {
    MicroRouteHandler h;

    MicroResponseSource() { this = h.getParameter(1) }

    override Http::RouteHandler getRouteHandler() { result = h }
  }

  class MicroRequestNode extends NodeJSLib::RequestNode {
    override MicroRequestSource src;
  }

  class MicroResponseNode extends NodeJSLib::ResponseNode {
    override MicroResponseSource src;
  }

  private Http::RouteHandler getRouteHandlerFromReqRes(DataFlow::Node node) {
    exists(Http::Servers::RequestSource src |
      src.ref().flowsTo(node) and
      result = src.getRouteHandler()
    )
    or
    exists(Http::Servers::ResponseSource src |
      src.ref().flowsTo(node) and
      result = src.getRouteHandler()
    )
  }

  class MicroBodyParserCall extends Http::RequestInputAccess, DataFlow::CallNode {
    string name;

    MicroBodyParserCall() {
      name = ["buffer", "text", "json"] and
      this = moduleMember("micro", name).getACall()
    }

    override string getKind() { result = "body" }

    override Http::RouteHandler getRouteHandler() {
      result = getRouteHandlerFromReqRes(this.getArgument(0))
    }

    override predicate isUserControlledObject() { name = "json" }
  }

  class MicroSendArgument extends Http::ResponseSendArgument {
    CallNode send;

    MicroSendArgument() {
      send = moduleMember("micro", ["send", "sendError"]).getACall() and
      this = send.getLastArgument()
    }

    override Http::RouteHandler getRouteHandler() {
      result = getRouteHandlerFromReqRes(send.getArgument([0, 1]))
    }
  }
}
