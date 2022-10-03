/**
 * Provides classes for working with [Spife](https://github.com/npm/spife) applications.
 */

import javascript
import semmle.javascript.frameworks.HTTP

/**
 * Provides classes for working with [Spife](https://github.com/npm/spife) applications.
 */
module Spife {
  /**
   * An API graph entry point ensuring all tagged template exprs are part of the API graph
   */
  private class TaggedTemplateEntryPoint extends API::EntryPoint {
    TaggedTemplateEntryPoint() { this = "TaggedTemplateEntryPoint" }

    override DataFlow::SourceNode getASource() { result.asExpr() instanceof TaggedTemplateExpr }
  }

  /**
   * A call to a Spife method that sets up a route.
   */
  private class RouteSetup extends API::CallNode, Http::Servers::StandardRouteSetup {
    TaggedTemplateExpr template;

    RouteSetup() {
      exists(CallExpr templateCall |
        this.getCalleeNode().asExpr() = template and
        API::moduleImport(["@npm/spife/routing", "spife/routing"])
            .asSource()
            .flowsToExpr(template.getTag()) and
        templateCall.getAChild() = template
      )
    }

    private string getRoutePattern() {
      // Concatenate the constant parts of the expression
      result =
        concat(Expr e, int i |
          e = template.getTemplate().getElement(i) and exists(e.getStringValue())
        |
          e.getStringValue() order by i
        )
    }

    private string getARouteLine() {
      result = this.getRoutePattern().splitAt("\n").regexpReplaceAll(" +", " ").trim()
    }

    private predicate hasLine(string method, string path, string handlerName) {
      exists(string line | line = this.getARouteLine() |
        line.splitAt(" ", 0) = method and
        line.splitAt(" ", 1) = path and
        line.splitAt(" ", 2) = handlerName
      )
    }

    API::Node getHandlerByName(string name) { result = this.getParameter(0).getMember(name) }

    API::Node getHandlerByRoute(string method, string path) {
      exists(string handlerName |
        this.hasLine(method, path, handlerName) and
        result = this.getHandlerByName(handlerName)
      )
    }

    override DataFlow::SourceNode getARouteHandler() {
      result = this.getHandlerByRoute(_, _).getAValueReachingSink().(DataFlow::FunctionNode)
      or
      exists(DataFlow::MethodCallNode validation |
        validation = this.getHandlerByRoute(_, _).getAValueReachingSink() and
        result = validation.getArgument(1).getAFunctionValue()
      )
    }

    override DataFlow::Node getServer() { none() }
  }

  /**
   * A Spife route handler.
   */
  abstract class RouteHandler extends Http::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    /**
     * Gets the parameter of the route handler that contains the request object.
     */
    DataFlow::ParameterNode getRequestParameter() { result = this.getParameter(0) }

    /**
     * Gets the parameter of the route handler that contains the context object.
     */
    DataFlow::ParameterNode getContextParameter() { result = this.getParameter(1) }
  }

  /**
   * A standard Spife route handler.
   */
  private class StandardRouteHandler extends RouteHandler, DataFlow::FunctionNode {
    StandardRouteHandler() { any(RouteSetup setup).getARouteHandler() = this }
  }

  /**
   * A function that looks like a Spife route handler.
   *
   * For example, this could be the function `function(req, res, next){...}`.
   */
  class RouteHandlerCandidate extends Http::RouteHandlerCandidate {
    RouteHandlerCandidate() {
      // heuristic: parameter names match the Restify documentation
      astNode.getNumParameter() = 2 and
      astNode.getParameter(0).getName() = ["request", "req"] and
      astNode.getParameter(1).getName() = ["context", "ctx"]
    }
  }

  /**
   * A Spife request source, that is, the request parameter of a
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
   * A Spife context source, that is, the context the parameter of a
   * route handler.
   */
  private class ContextSource extends Http::Servers::RequestSource {
    RouteHandler rh;

    ContextSource() { this = rh.getContextParameter() }

    /**
     * Gets the route handler that handles this request.
     */
    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An access to a user-controlled Spife request input.
   */
  private class RequestInputAccess extends Http::RequestInputAccess {
    RouteHandler rh;
    string kind;

    RequestInputAccess() {
      this = rh.getARequestSource().ref().getAPropertyRead("body") and
      kind = "body"
      or
      this = rh.getARequestSource().ref().getAPropertyRead("query").getAPropertyRead() and
      kind = "parameter"
      or
      this = rh.getARequestSource().ref().getAPropertyRead("raw") and
      kind = "raw"
      or
      this = rh.getARequestSource().ref().getAPropertyRead(["url", "urlObject"]) and
      kind = "url"
      or
      this = rh.getARequestSource().ref().getAMethodCall() and
      this.(DataFlow::MethodCallNode).getMethodName() = ["cookie", "cookies"] and
      kind = "cookie"
      or
      exists(DataFlow::PropRead validated, DataFlow::MethodCallNode get |
        rh.getARequestSource().ref().getAPropertyRead() = validated and
        validated.getPropertyName().matches("validated%") and
        get.getReceiver() = validated and
        this = get and
        kind = "body"
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = kind }
  }

  /**
   * An access to a user-controlled Spife context input.
   */
  private class ContextInputAccess extends Http::RequestInputAccess {
    ContextSource request;
    string kind;

    ContextInputAccess() {
      request.ref().flowsTo(this.(DataFlow::MethodCallNode).getReceiver()) and
      this.(DataFlow::MethodCallNode).getMethodName() = "get" and
      kind = "path"
    }

    override RouteHandler getRouteHandler() { result = request.getRouteHandler() }

    override string getKind() { result = kind }
  }

  /**
   * An access to a header on a Spife request.
   */
  private class RequestHeaderAccess extends Http::RequestHeaderAccess {
    RouteHandler rh;

    RequestHeaderAccess() {
      this =
        rh.getARequestSource().ref().getAPropertyRead(["headers", "rawHeaders"]).getAPropertyRead()
    }

    override string getAHeaderName() {
      result = this.(DataFlow::PropRead).getPropertyName().toLowerCase()
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = "header" }
  }

  /**
   * A Spife response source, that is, the response variable used by a
   * route handler.
   */
  private class ReplySource extends Http::Servers::ResponseSource {
    ReplySource() {
      // const reply = require("@npm/spife/reply")
      // reply(resp)
      // reply.header(resp, 'foo', 'bar')
      this = API::moduleImport(["@npm/spife/reply", "spife/reply"]).getACall() or
      this = API::moduleImport(["@npm/spife/reply", "spife/reply"]).getAMember().getACall()
    }

    private DataFlow::SourceNode reachesHandlerReturn(
      DataFlow::CallNode headerCall, DataFlow::TypeTracker t
    ) {
      result = headerCall and
      t.start()
      or
      exists(DataFlow::TypeTracker t2 |
        result = this.reachesHandlerReturn(headerCall, t2).track(t2, t)
      )
    }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() {
      exists(RouteHandler handler |
        handler.(DataFlow::FunctionNode).getAReturn().getALocalSource() =
          this.reachesHandlerReturn(this, DataFlow::TypeTracker::end()) and
        result = handler
      )
    }
  }

  /**
   * An HTTP header defined in a Spife response.
   */
  private class HeaderDefinition extends Http::ExplicitHeaderDefinition, DataFlow::MethodCallNode {
    ReplySource reply;

    HeaderDefinition() {
      // reply.header(RESPONSE, 'Cache-Control', 'no-cache')
      reply.ref().(DataFlow::MethodCallNode).getMethodName() = "header" and
      reply.ref().(DataFlow::MethodCallNode).getNumArgument() = 3 and
      this = reply
    }

    override predicate definesHeaderValue(string headerName, DataFlow::Node headerValue) {
      // reply.header(RESPONSE, 'Cache-Control', 'no-cache')
      headerName = this.getNameNode().getStringValue() and
      headerValue = this.getArgument(2)
    }

    override DataFlow::Node getNameNode() { result = this.getArgument(1) }

    override RouteHandler getRouteHandler() { result = reply.getRouteHandler() }
  }

  /**
   * An invocation that sets any number of headers of the HTTP response.
   */
  private class MultipleHeaderDefinitions extends Http::ExplicitHeaderDefinition, DataFlow::CallNode {
    ReplySource reply;

    MultipleHeaderDefinitions() {
      // reply.header(RESPONSE, {'Cache-Control': 'no-cache'})
      // reply(RESPONSE, {'Cache-Control': 'no-cache'})
      reply.ref().(DataFlow::CallNode).getCalleeName() = ["header", "reply"] and
      reply.ref().(DataFlow::CallNode).getAnArgument().getALocalSource() instanceof
        DataFlow::ObjectLiteralNode and
      this = reply
    }

    /**
     * Gets a reference to the multiple headers object that is to be set.
     */
    private DataFlow::SourceNode getAHeaderSource() {
      exists(int i |
        this.getArgument(i).getALocalSource() instanceof DataFlow::ObjectLiteralNode and
        result.flowsTo(this.getArgument(i))
      )
    }

    override predicate definesHeaderValue(string headerName, DataFlow::Node headerValue) {
      exists(string header |
        this.getAHeaderSource().hasPropertyWrite(header, headerValue) and
        headerName = header.toLowerCase()
      )
    }

    override DataFlow::Node getNameNode() {
      exists(DataFlow::PropWrite write | this.getAHeaderSource().getAPropertyWrite() = write |
        result = write.getPropertyNameExpr().flow()
      )
    }

    override RouteHandler getRouteHandler() { result = reply.getRouteHandler() }
  }

  /**
   * A header produced by a route handler with no explicit declaration of a Content-Type.
   */
  private class ContentTypeRouteHandlerHeader extends Http::ImplicitHeaderDefinition,
    DataFlow::FunctionNode {
    ContentTypeRouteHandlerHeader() { this instanceof RouteHandler }

    override predicate defines(string headerName, string headerValue) {
      headerName = "content-type" and headerValue = "application/json"
    }

    override Http::RouteHandler getRouteHandler() { result = this }
  }

  /**
   * An HTTP cookie defined in a Spife HTTP response.
   */
  private class CookieDefinition extends Http::CookieDefinition, DataFlow::MethodCallNode {
    ReplySource reply;

    CookieDefinition() {
      // reply.cookie(RESPONSE, 'TEST', 'FOO', {"maxAge": 1000, "httpOnly": true, "secure": true})
      this = reply.ref().(DataFlow::MethodCallNode) and
      this.getMethodName() = "cookie"
    }

    override DataFlow::Node getNameArgument() { result = this.getArgument(1) }

    override DataFlow::Node getValueArgument() { result = this.getArgument(2) }

    override RouteHandler getRouteHandler() { result = reply.getRouteHandler() }
  }

  /**
   * A response argument passed to the `reply` method.
   */
  private class ReplyArgument extends Http::ResponseSendArgument, DataFlow::Node {
    RouteHandler rh;

    ReplyArgument() {
      exists(ReplySource reply |
        reply.ref().(DataFlow::CallNode).getCalleeName() =
          ["reply", "cookie", "link", "header", "headers", "raw", "status", "toStream", "vary"] and
        this = reply.ref().(DataFlow::CallNode).getArgument(0) and
        rh = reply.getRouteHandler()
      )
      or
      this = rh.(DataFlow::FunctionNode).getAReturn()
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An expression passed to the `template` method of the reply object
   * as the value of a template variable.
   */
  private class TemplateInput extends Http::ResponseBody {
    TemplateObjectInput obj;

    TemplateInput() {
      obj.getALocalSource().(DataFlow::ObjectLiteralNode).hasPropertyWrite(_, this)
    }

    override RouteHandler getRouteHandler() { result = obj.getRouteHandler() }
  }

  /**
   * An object passed to the `template` method of the reply object.
   */
  private class TemplateObjectInput extends DataFlow::Node {
    ReplySource reply;

    TemplateObjectInput() {
      reply.ref().(DataFlow::MethodCallNode).getMethodName() = "template" and
      this = reply.ref().(DataFlow::MethodCallNode).getArgument(1)
    }

    /**
     * Gets the route handler that uses this object.
     */
    RouteHandler getRouteHandler() { result = reply.getRouteHandler() }
  }

  /**
   * An invocation of the `redirect` method of an HTTP response object.
   */
  private class RedirectInvocation extends Http::RedirectInvocation, DataFlow::MethodCallNode {
    ReplySource reply;

    RedirectInvocation() {
      this = reply.ref().(DataFlow::MethodCallNode) and
      this.getMethodName() = "redirect"
    }

    override DataFlow::Node getUrlArgument() { result = this.getAnArgument() }

    override RouteHandler getRouteHandler() { result = reply.getRouteHandler() }
  }

  /**
   * A call to `reply.template('template', { ... })`, seen as a template instantiation.
   */
  private class TemplateCall extends Templating::TemplateInstantiation::Range, DataFlow::CallNode {
    TemplateCall() {
      exists(ReplySource reply |
        reply.ref().(DataFlow::MethodCallNode).getMethodName() = "template" and
        this = reply.ref()
      )
    }

    override DataFlow::SourceNode getOutput() { result = this }

    override DataFlow::Node getTemplateFileNode() { result = this.getArgument(0) }

    override DataFlow::Node getTemplateParamsNode() { result = this.getArgument(1) }
  }
}
