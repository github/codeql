/**
 * Provides classes for working with [Restify](https://restify.com/) servers.
 */

import javascript
import semmle.javascript.frameworks.HTTP
import semmle.javascript.security.dataflow.RequestForgeryCustomizations as RFC

/**
 * Provides classes for working with [Restify](https://restify.com/) servers.
 */
module Restify {
  /**
   * An expression that creates a new Restify server.
   */
  class ServerDefinition extends Http::Servers::StandardServerDefinition, DataFlow::CallNode {
    ServerDefinition() {
      // `server = restify.createServer()`
      this = DataFlow::moduleMember("restify", "createServer").getACall()
    }
  }

  /**
   * A Restify route handler.
   */
  abstract class RouteHandler extends Http::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    /**
     * Gets the parameter of the route handler that contains the request object.
     */
    DataFlow::ParameterNode getRequestParameter() { result = this.getParameter(0) }

    /**
     * Gets the parameter of the route handler that contains the response object.
     */
    DataFlow::ParameterNode getResponseParameter() { result = this.getParameter(1) }
  }

  /**
   * A standard Restify route handler.
   */
  class StandardRouteHandler extends RouteHandler, DataFlow::FunctionNode {
    StandardRouteHandler() { any(RouteSetup setup).getARouteHandler() = this }
  }

  /**
   * A Restify response source, that is, the response parameter of a
   * route handler.
   */
  private class ResponseSource extends Http::Servers::ResponseSource {
    RouteHandler rh;

    ResponseSource() { this = rh.getResponseParameter() }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A Restify request source, that is, the request parameter of a
   * route handler.
   */
  private class RequestSource extends Http::Servers::RequestSource {
    RouteHandler rh;

    RequestSource() { this = rh.getRequestParameter() }

    /**
     * Gets the route handler that handles this request.
     */
    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A Node.js HTTP response provided by Restify.
   */
  class ResponseNode extends NodeJSLib::ResponseNode {
    ResponseNode() { src instanceof ResponseSource or src instanceof FormatterResponseSource }
  }

  /**
   * A Node.js HTTP request provided by Restify.
   */
  class RequestNode extends NodeJSLib::RequestNode {
    RequestNode() { src instanceof RequestSource or src instanceof FormatterRequestSource }
  }

  /**
   * An access to a user-controlled Restify request input.
   */
  private class RequestInputAccess extends Http::RequestInputAccess {
    Http::RequestNode request;
    string kind;

    RequestInputAccess() {
      exists(DataFlow::MethodCallNode query |
        // `request.getQuery().<name>`
        kind = "parameter" and
        query.calls(request, "getQuery") and
        this.(DataFlow::PropRead).accesses(query, _)
      )
      or
      exists(DataFlow::PropRead prop |
        // `request.params.<name>`
        // `request.query.<name>`
        kind = "parameter" and
        prop.accesses(request, ["params", "query"]) and
        this.(DataFlow::PropRead).accesses(prop, _)
      )
      or
      // `request.href()` or `request.getPath()`
      kind = "url" and
      this.(DataFlow::MethodCallNode).calls(request, ["href", "getPath"])
    }

    override RouteHandler getRouteHandler() { result = request.getRouteHandler() }

    override string getKind() { result = kind }
  }

  /**
   * An access to a header on a Restify request.
   */
  private class RequestHeaderAccess extends Http::RequestHeaderAccess instanceof DataFlow::MethodCallNode
  {
    RouteHandler rh;

    RequestHeaderAccess() {
      // `request.getContentType()`, `request.userAgent()`, `request.trailer(...)`, `request.header(...)`
      this =
        rh.getARequestSource()
            .ref()
            .getAMethodCall(["header", "trailer", "userAgent", "getContentType"])
    }

    override string getAHeaderName() {
      super.getArgument(0).mayHaveStringValue(any(string s | s.toLowerCase() = result))
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = "header" }
  }

  /**
   * An HTTP header defined in a Restify server.
   */
  private class HeaderDefinition extends Http::Servers::StandardHeaderDefinition {
    HeaderDefinition() {
      // res.header('Cache-Control', 'no-cache')
      this.getReceiver() instanceof ResponseNode and
      this.getMethodName() = "header"
    }

    override RouteHandler getRouteHandler() { this.getReceiver() = result.getAResponseNode() }
  }

  /**
   * An invocation that sets any number of headers of the HTTP response.
   */
  private class MultipleHeaderDefinitions extends Http::ExplicitHeaderDefinition,
    DataFlow::MethodCallNode
  {
    MultipleHeaderDefinitions() {
      // res.set({'Cache-Control': 'no-cache'})
      this.getReceiver() instanceof ResponseNode and
      this.getMethodName() = "set"
    }

    /**
     * Gets a reference to the multiple headers object that is to be set.
     */
    private DataFlow::ObjectLiteralNode getAHeaderSource() {
      result = this.getArgument(0).getALocalSource()
    }

    override predicate definesHeaderValue(string headerName, DataFlow::Node headerValue) {
      exists(string header |
        this.getAHeaderSource().hasPropertyWrite(header, headerValue) and
        headerName = header.toLowerCase()
      )
    }

    override DataFlow::Node getNameNode() {
      result = this.getAHeaderSource().getAPropertyWrite().getPropertyNameExpr().flow()
    }

    override RouteHandler getRouteHandler() { this.getReceiver() = result.getAResponseNode() }
  }

  /**
   * A call to a Restify method that sets up a route.
   */
  class RouteSetup extends DataFlow::MethodCallNode, Http::Servers::StandardRouteSetup {
    ServerDefinition server;

    RouteSetup() {
      server
          .ref()
          .getAMethodCall([
              "del", "get", "head", "opts", "post", "put", "patch", "param", "pre", "use", "on"
            ]) = this
    }

    override DataFlow::SourceNode getARouteHandler() {
      exists(DataFlow::Node arg |
        // server.get('/', fun)
        // server.get('/', fun1, fun2)
        // server.get('/', [fun1, fun2])
        // server.param('name', fun)
        // server.on('event', fun)
        this.getMethodName() = ["del", "get", "head", "opts", "post", "put", "patch", "param", "on"] and
        arg = this.getAnArgument() and
        not arg = this.getArgument(0)
        or
        // server.use(fun)
        // server.use(fun1, fun2)
        // server.use([fun1, fun2])
        this.getMethodName() = ["use", "pre"] and
        arg = this.getAnArgument()
      |
        (
          // server.use(fun1, fun2)
          result.flowsTo(arg) and
          not arg.getALocalSource() instanceof DataFlow::ArrayCreationNode
          or
          result.flowsTo(arg.getALocalSource().(DataFlow::ArrayCreationNode).getAnElement())
        )
      )
    }

    override DataFlow::Node getServer() { result = server }
  }

  /**
   * A call to a Restify's createServer method that sets up a formatter.
   */
  class FormatterSetup extends DataFlow::CallNode {
    DataFlow::ObjectLiteralNode formatters;

    FormatterSetup() {
      // `server = restify.createServer({ formatters: { ... } })`
      this = DataFlow::moduleMember("restify", "createServer").getACall() and
      this.getArgument(0)
          .getALocalSource()
          .(DataFlow::ObjectLiteralNode)
          .hasPropertyWrite("formatters", formatters)
    }

    /**
     * Gets the formatter handler installed by this setup.
     */
    DataFlow::FunctionNode getAFormatterHandler() {
      result = formatters.getAPropertyWrite().getRhs().getALocalSource()
    }
  }

  /**
   * A Restify route handler.
   */
  class FormatterHandler extends Http::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    FormatterHandler() { any(FormatterSetup setup).getAFormatterHandler() = this }

    /**
     * Gets the parameter of the formatter handler that contains the request object.
     */
    DataFlow::ParameterNode getRequestParameter() { result = this.getParameter(0) }

    /**
     * Gets the parameter of the formatter handler that contains the response object.
     */
    DataFlow::ParameterNode getResponseParameter() { result = this.getParameter(1) }

    /**
     * Gets the parameter of the formatter handler that contains the body object.
     */
    DataFlow::ParameterNode getBodyParameter() { result = this.getParameter(2) }
  }

  /**
   * A Restify request source, that is, the request parameter of a
   * route handler.
   */
  private class FormatterRequestSource extends Http::Servers::RequestSource {
    FormatterHandler fh;

    FormatterRequestSource() { this = fh.getRequestParameter() }

    /**
     * Gets the formatter handler that handles this request.
     */
    override RouteHandler getRouteHandler() { result = fh }
  }

  /**
   * A Restify response source, that is, the response parameter of a
   * route handler.
   */
  private class FormatterResponseSource extends Http::Servers::ResponseSource {
    FormatterHandler fh;

    FormatterResponseSource() { this = fh.getResponseParameter() }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = fh }
  }

  /**
   * An argument passed to the `send` method of an HTTP response object.
   */
  private class ResponseSendArgument extends Http::ResponseSendArgument {
    RouteHandler rh;

    ResponseSendArgument() {
      this = rh.getAResponseSource().ref().getAMethodCall(["send", "sendRaw"]).getArgument(0)
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An expression returned by a formatter
   */
  private class FormatterOutput extends Http::ResponseSendArgument {
    FormatterHandler fh;

    FormatterOutput() { this = fh.getAReturn() }

    override Http::RouteHandler getRouteHandler() { result = fh }
  }

  /**
   * An invocation of the `redirect` method of an HTTP response object.
   */
  private class RedirectInvocation extends Http::RedirectInvocation, DataFlow::MethodCallNode {
    RouteHandler rh;

    RedirectInvocation() { this = rh.getAResponseSource().ref().getAMethodCall("redirect") }

    override DataFlow::Node getUrlArgument() {
      this.getNumArgument() = 3 and
      result = this.getArgument(1)
      or
      this.getNumArgument() = 2 and
      this.getArgument(0).getALocalSource().hasPropertyWrite("hostname", result)
      or
      this.getNumArgument() = 2 and
      result = this.getArgument(0)
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A function that looks like a Restify route handler.
   *
   * For example, this could be the function `function(req, res, next){...}`.
   */
  class RouteHandlerCandidate extends Http::RouteHandlerCandidate {
    RouteHandlerCandidate() {
      // heuristic: parameter names match the Restify documentation
      astNode.getNumParameter() = [2, 3] and
      astNode.getParameter(0).getName() = ["request", "req"] and
      astNode.getParameter(1).getName() = ["response", "res"] and
      not astNode.getParameter(2).getName() != "next" and
      // heuristic: is not invoked (Restify invokes this at a call site we cannot reason precisely about)
      not exists(DataFlow::InvokeNode cs | cs.getACallee() = astNode)
    }
  }

  /**
   * The URL of a Restify client, viewed as a sink for request forgery.
   */
  class RequestForgerySink extends RFC::RequestForgery::Sink {
    RequestForgerySink() {
      exists(DataFlow::Node arg |
        DataFlow::moduleMember("restify-clients",
          ["createClient", "createJsonClient", "createStringClient"]).getACall().getArgument(0) =
          arg and
        (
          arg.getALocalSource().(DataFlow::ObjectLiteralNode).hasPropertyWrite("url", this)
          or
          not arg.getALocalSource() instanceof DataFlow::ObjectLiteralNode and
          this = arg
        )
      )
    }

    override DataFlow::Node getARequest() {
      // returning the createClient argument itself since there is no request associated to the client yet.
      // `getARequest()` is only used for display purposes
      result = this
    }

    override string getKind() { result = "host" }
  }

  /**
   * A header produced by a formatter
   */
  private class FormatterContentTypeHeader extends Http::ImplicitHeaderDefinition,
    DataFlow::FunctionNode instanceof FormatterHandler
  {
    string contentType;

    FormatterContentTypeHeader() {
      exists(DataFlow::PropWrite write |
        write.getRhs() = this and
        write.getPropertyName() = contentType
      )
    }

    override predicate defines(string headerName, string headerValue) {
      headerName = "content-type" and headerValue = contentType
    }

    override Http::RouteHandler getRouteHandler() { result = this }
  }

  /**
   * A header produced by a route handler with no explicit declaration of a Content-Type.
   */
  private class ContentTypeRouteHandlerHeader extends Http::ImplicitHeaderDefinition,
    DataFlow::FunctionNode instanceof RouteHandler
  {
    override predicate defines(string headerName, string headerValue) {
      headerName = "content-type" and headerValue = "application/json"
    }

    override Http::RouteHandler getRouteHandler() { result = this }
  }

  /** A Restify router */
  private class RouterRange extends Routing::Router::Range {
    ServerDefinition def;

    RouterRange() { this = def }

    override DataFlow::SourceNode getAReference() { result = def.ref() }
  }

  private class RoutingTreeSetup extends Routing::RouteSetup::MethodCall instanceof RouteSetup {
    override string getRelativePath() {
      not this.getMethodName() = ["use", "pre", "param", "on"] and // do not treat parameter name as a path
      result = this.getArgument(0).getStringValue()
    }

    override Http::RequestMethodName getHttpMethod() { result.toLowerCase() = this.getMethodName() }
  }
}
