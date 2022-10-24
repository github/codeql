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
      this.getCalleeNode().asExpr() = template and
      API::moduleImport(["@npm/spife/routing", "spife/routing"])
          .asSource()
          .flowsToExpr(template.getTag())
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
  private class ContextInputAccess extends Http::RequestInputAccess instanceof DataFlow::MethodCallNode {
    ContextSource request;
    string kind;

    ContextInputAccess() {
      this = request.ref().getAMethodCall("get")
      kind = "path"
    }

    override RouteHandler getRouteHandler() { result = request.getRouteHandler() }

    override string getKind() { result = kind }
  }

  /**
   * An access to a header on a Spife request.
   */
  private class RequestHeaderAccess extends Http::RequestHeaderAccess instanceof DataFlow::PropRead {
    RouteHandler rh;

    RequestHeaderAccess() {
      this =
        rh.getARequestSource().ref().getAPropertyRead(["headers", "rawHeaders"]).getAPropertyRead()
    }

    override string getAHeaderName() { result = super.getPropertyName().toLowerCase() }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = "header" }
  }

  /**
   * A Spife response source, that is, the response variable used by a
   * route handler.
   */
  private class ReplySource extends Http::Servers::ResponseSource instanceof DataFlow::CallNode {
    ReplySource() {
      // const reply = require("@npm/spife/reply")
      // reply(resp)
      // reply.header(resp, 'foo', 'bar')
      this = API::moduleImport(["@npm/spife/reply", "spife/reply"]).getACall() or
      this = API::moduleImport(["@npm/spife/reply", "spife/reply"]).getAMember().getACall()
    }

    private DataFlow::SourceNode reachesHandlerReturn(DataFlow::TypeTracker t) {
      result = this and
      t.start()
      or
      exists(DataFlow::TypeTracker t2 | result = this.reachesHandlerReturn(t2).track(t2, t))
    }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() {
      exists(RouteHandler handler |
        handler.(DataFlow::FunctionNode).getAReturn().getALocalSource() =
          this.reachesHandlerReturn(DataFlow::TypeTracker::end()) and
        result = handler
      )
    }
  }

  /**
   * An HTTP header defined in a Spife response.
   */
  private class HeaderDefinition extends Http::ExplicitHeaderDefinition, DataFlow::MethodCallNode instanceof ReplySource {
    HeaderDefinition() {
      // reply.header(RESPONSE, 'Cache-Control', 'no-cache')
      exists(DataFlow::MethodCallNode call |
        this.ref() = call and
        call.getMethodName() = "header" and
        call.getNumArgument() = 3
      )
    }

    override predicate definesHeaderValue(string headerName, DataFlow::Node headerValue) {
      // reply.header(RESPONSE, 'Cache-Control', 'no-cache')
      this.getNameNode().mayHaveStringValue(headerName) and
      headerValue = this.getArgument(2)
    }

    override DataFlow::Node getNameNode() { result = this.getArgument(1) }

    override RouteHandler getRouteHandler() { result = this.getRouteHandler() }
  }

  /**
   * An invocation that sets any number of headers of the HTTP response.
   */
  private class MultipleHeaderDefinitions extends Http::ExplicitHeaderDefinition, DataFlow::CallNode {
    ReplySource reply;

    MultipleHeaderDefinitions() {
      // reply.header(RESPONSE, {'Cache-Control': 'no-cache'})
      // reply(RESPONSE, {'Cache-Control': 'no-cache'})
      exists(DataFlow::CallNode call | call = [reply.ref(), reply.ref().getAMethodCall("header")] | 
        call.getAnArgument().getALocalSource() instanceof DataFlow::ObjectLiteralNode and
        this = call
      )
    }

    /**
     * Gets a reference to the multiple headers object that is to be set.
     */
    private DataFlow::ObjectLiteralNode getAHeaderSource() {
      result = this.getAnArgument().getALocalSource()
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

    override RouteHandler getRouteHandler() { result = reply.getRouteHandler() }
  }

  /**
   * A header produced by a route handler with no explicit declaration of a Content-Type.
   */
  private class ContentTypeRouteHandlerHeader extends Http::ImplicitHeaderDefinition,
    DataFlow::FunctionNode instanceof RouteHandler {
    override predicate defines(string headerName, string headerValue) {
      headerName = "content-type" and headerValue = "application/json"
    }

    override Http::RouteHandler getRouteHandler() { result = this }
  }

  /**
   * An HTTP cookie defined in a Spife HTTP response.
   */
  private class CookieDefinition extends Http::CookieDefinition, DataFlow::MethodCallNode {
    CookieDefinition() {
      // reply.cookie(RESPONSE, 'TEST', 'FOO', {"maxAge": 1000, "httpOnly": true, "secure": true})
      this = any(ReplySource r).ref().getAMethodCall("cookie")
    }

    override DataFlow::Node getNameArgument() { result = this.getArgument(1) }

    override DataFlow::Node getValueArgument() { result = this.getArgument(2) }

    override RouteHandler getRouteHandler() { result = this.getRouteHandler() }
  }

  /**
   * A response argument passed to the `reply` method.
   */
  private class ReplyArgument extends Http::ResponseSendArgument, DataFlow::Node {
    RouteHandler rh;

    ReplyArgument() {
      exists(ReplySource reply, DataFlow::CallNode call |
        reply.ref() = call and
        call.getCalleeName() =
          ["reply", "cookie", "link", "header", "headers", "raw", "status", "toStream", "vary"] and
        this = call.getArgument(0) and
        rh = reply.getRouteHandler()
      )
      or
      this = rh.getAReturn()
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
      exists(DataFlow::MethodCallNode call |
        reply.ref() = call and
        call.getMethodName() = "template" and
        this = call.getArgument(1)
      )
    }

    /**
     * Gets the route handler that uses this object.
     */
    RouteHandler getRouteHandler() { result = reply.getRouteHandler() }
  }

  /**
   * An invocation of the `redirect` method of an HTTP response object.
   */
  private class RedirectInvocation extends Http::RedirectInvocation, DataFlow::MethodCallNode instanceof ReplySource {
    RedirectInvocation() { this.ref().(DataFlow::MethodCallNode).getMethodName() = "redirect" }

    override DataFlow::Node getUrlArgument() { result = this.getAnArgument() }

    override RouteHandler getRouteHandler() { result = this.getRouteHandler() }
  }

  /**
   * A call to `reply.template('template', { ... })`, seen as a template instantiation.
   */
  private class TemplateCall extends Templating::TemplateInstantiation::Range,
    DataFlow::MethodCallNode instanceof ReplySource {
    TemplateCall() { this.getMethodName() = "template" }

    override DataFlow::SourceNode getOutput() { result = this }

    override DataFlow::Node getTemplateFileNode() { result = this.getArgument(0) }

    override DataFlow::Node getTemplateParamsNode() { result = this.getArgument(1) }
  }
}
