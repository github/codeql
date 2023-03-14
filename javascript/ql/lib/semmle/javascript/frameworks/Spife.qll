/**
 * Provides classes for working with [Spife](https://github.com/npm/spife) applications.
 */

import javascript
import semmle.javascript.frameworks.HTTP
private import DataFlow

/**
 * Provides classes for working with [Spife](https://github.com/npm/spife) applications.
 */
module Spife {
  /**
   * A call to a Spife method that sets up a route.
   */
  private class RouteSetup extends DataFlow::CallNode, Http::Servers::StandardRouteSetup {
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
        strictconcat(Expr e, int i |
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

    DataFlow::SourceNode getHandlerDefinitions(TypeBackTracker t) {
      t.start() and
      result = this.getArgument(0).getALocalSource()
      or
      exists(TypeBackTracker t2 | result = this.getHandlerDefinitions(t2).backtrack(t2, t))
    }

    DataFlow::SourceNode getHandlerDefinitions() {
      result = this.getHandlerDefinitions(TypeBackTracker::end())
    }

    DataFlow::SourceNode getHandlerByName(string name) {
      result = this.getHandlerDefinitions().getAPropertySource(name)
    }

    DataFlow::SourceNode getHandlerByRoute(string method, string path) {
      exists(string handlerName |
        this.hasLine(method, path, handlerName) and
        result = this.getHandlerByName(handlerName)
      )
    }

    override DataFlow::SourceNode getARouteHandler() {
      result = this.getHandlerByRoute(_, _).getALocalSource().(DataFlow::FunctionNode)
      or
      exists(DataFlow::MethodCallNode validation |
        validation = this.getHandlerByRoute(_, _).getALocalSource() and
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
   * For example, this could be the function `function(request, context){...}`.
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
      // req.body
      this = rh.getARequestSource().ref().getAPropertyRead("body") and
      kind = "body"
      or
      // req.query['foo']
      this = rh.getARequestSource().ref().getAPropertyRead("query").getAPropertyRead() and
      kind = "parameter"
      or
      // req.raw
      this = rh.getARequestSource().ref().getAPropertyRead("raw") and
      kind = "raw"
      or
      // req.url
      // req.urlObject
      this = rh.getARequestSource().ref().getAPropertyRead(["url", "urlObject"]) and
      kind = "url"
      or
      // req.cookie('foo')
      // req.cookies()
      this = rh.getARequestSource().ref().getAMethodCall() and
      this.(DataFlow::MethodCallNode).getMethodName() = ["cookie", "cookies"] and
      kind = "cookie"
      or
      // req.validatedBody.get('foo')
      this =
        rh.getARequestSource()
            .ref()
            .getAPropertyRead(any(string s | s.matches("validated%")))
            .getAMethodCall("get") and
      kind = "body"
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = kind }
  }

  /**
   * An access to a user-controlled Spife context input.
   */
  private class ContextInputAccess extends Http::RequestInputAccess instanceof DataFlow::MethodCallNode
  {
    ContextSource request;
    string kind;

    ContextInputAccess() {
      this = request.ref().getAMethodCall("get") and
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
  private class ReplyCall extends API::CallNode {
    boolean isDirectReplyCall;

    ReplyCall() {
      // reply(resp)
      this = API::moduleImport(["@npm/spife/reply", "spife/reply"]).getACall() and
      isDirectReplyCall = true
      or
      // reply.header(resp, 'foo', 'bar')
      this = API::moduleImport(["@npm/spife/reply", "spife/reply"]).getAMember().getACall() and
      isDirectReplyCall = false
    }

    predicate isDirectReplyCall() { isDirectReplyCall = true }

    /**
     * Gets the route handler that provides this response.
     */
    RouteHandler getRouteHandler() {
      result.getAReturn() = this.getReturn().getAValueReachableFromSource()
    }
  }

  /**
   * An HTTP header defined in a Spife response.
   */
  private class SingleHeaderDefinition extends Http::ExplicitHeaderDefinition instanceof ReplyCall {
    SingleHeaderDefinition() {
      // reply.header(RESPONSE, 'Cache-Control', 'no-cache')
      this.getCalleeName() = "header" and
      this.getNumArgument() = 3
    }

    override predicate definesHeaderValue(string headerName, DataFlow::Node headerValue) {
      // reply.header(RESPONSE, 'Cache-Control', 'no-cache')
      this.getNameNode().mayHaveStringValue(headerName) and
      headerValue = super.getArgument(2)
    }

    override DataFlow::Node getNameNode() { result = super.getArgument(1) }

    override RouteHandler getRouteHandler() { result = ReplyCall.super.getRouteHandler() }
  }

  /**
   * An invocation that sets any number of headers of the HTTP response.
   */
  private class MultipleHeaderDefinitions extends Http::ExplicitHeaderDefinition instanceof ReplyCall
  {
    MultipleHeaderDefinitions() {
      (
        // reply.header(RESPONSE, {'Cache-Control': 'no-cache'})
        this.getCalleeName() = "header"
        or
        // reply(RESPONSE, {'Cache-Control': 'no-cache'})
        this.isDirectReplyCall()
      ) and
      this.getAnArgument().getALocalSource() instanceof DataFlow::ObjectLiteralNode
    }

    /**
     * Gets a reference to the multiple headers object that is to be set.
     */
    DataFlow::ObjectLiteralNode getAHeaderSource() {
      result = super.getAnArgument().getALocalSource()
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

    override RouteHandler getRouteHandler() { result = ReplyCall.super.getRouteHandler() }
  }

  /**
   * A header produced by a route handler with no explicit declaration of a Content-Type.
   */
  private class ContentTypeRouteHandlerHeader extends Http::ImplicitHeaderDefinition instanceof RouteHandler
  {
    override predicate defines(string headerName, string headerValue) {
      headerName = "content-type" and headerValue = "application/json"
    }

    override RouteHandler getRouteHandler() { result = this }
  }

  /**
   * An HTTP cookie defined in a Spife HTTP response.
   */
  private class CookieDefinition extends Http::CookieDefinition instanceof ReplyCall {
    CookieDefinition() {
      // reply.cookie(RESPONSE, 'TEST', 'FOO', {"maxAge": 1000, "httpOnly": true, "secure": true})
      this.getCalleeName() = "cookie"
    }

    //  this = any(ReplyCall r).ref().getAMethodCall("cookie")
    override DataFlow::Node getNameArgument() { result = super.getArgument(1) }

    override DataFlow::Node getValueArgument() { result = super.getArgument(2) }

    override RouteHandler getRouteHandler() { result = ReplyCall.super.getRouteHandler() }
  }

  /**
   * A response sent using a method on the `reply` object.
   */
  private class ReplyMethodCallArgument extends Http::ResponseSendArgument {
    ReplyCall reply;

    ReplyMethodCallArgument() {
      // reply.header(RESPONSE, {'Cache-Control': 'no-cache'})
      reply.getCalleeName() =
        ["cookie", "link", "header", "headers", "raw", "status", "toStream", "vary"] and
      reply.getArgument(0) = this
    }

    override RouteHandler getRouteHandler() { result = reply.getRouteHandler() }
  }

  /**
   * A response sent using the `reply()` method.
   */
  private class ReplyCallArgument extends Http::ResponseSendArgument {
    ReplyCall reply;

    ReplyCallArgument() {
      // reply(RESPONSE, {'Cache-Control': 'no-cache'})
      reply.isDirectReplyCall() and
      reply.getArgument(0) = this
    }

    override RouteHandler getRouteHandler() { result = reply.getRouteHandler() }
  }

  /**
   * The return statement for a route handler.
   */
  private class RouteHandlerReturn extends Http::ResponseSendArgument {
    RouteHandler rh;

    RouteHandlerReturn() {
      this = rh.getAReturn() and not this.getALocalSource() instanceof ReplyCall
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A call to `reply.template('template', { ... })`, seen as a template instantiation.
   */
  private class TemplateCall extends Templating::TemplateInstantiation::Range instanceof ReplyCall {
    TemplateCall() { this.getCalleeName() = "template" }

    override DataFlow::SourceNode getOutput() { result = this }

    override DataFlow::Node getTemplateFileNode() { result = super.getArgument(0) }

    override DataFlow::Node getTemplateParamsNode() { result = super.getArgument(1) }
  }

  /**
   * An object passed to the `template` method of the reply object.
   */
  private class TemplateObjectInput extends DataFlow::Node {
    ReplyCall call;

    TemplateObjectInput() { this = call.getArgument(1) }

    /**
     * Gets the route handler that uses this object.
     */
    RouteHandler getRouteHandler() { result = call.getRouteHandler() }
  }

  /**
   * An expression passed to the `template` method of the reply object
   * as the value of a template variable.
   */
  private class TemplateInput extends Http::ResponseBody {
    TemplateObjectInput obj;

    TemplateInput() { obj.getALocalSource().hasPropertyWrite(_, this) }

    override RouteHandler getRouteHandler() { result = obj.getRouteHandler() }
  }

  /**
   * An invocation of the `redirect` method of an HTTP response object.
   */
  private class RedirectInvocation extends Http::RedirectInvocation instanceof ReplyCall {
    RedirectInvocation() { this.getCalleeName() = "redirect" }

    override DataFlow::Node getUrlArgument() { result = this.getAnArgument() }

    override RouteHandler getRouteHandler() { result = ReplyCall.super.getRouteHandler() }
  }
}
