/**
 * Provides classes for modeling common HTTP concepts.
 */

import javascript
private import semmle.javascript.DynamicPropertyAccess
private import semmle.javascript.dataflow.internal.StepSummary
private import semmle.javascript.dataflow.internal.CallGraphs
private import DataFlow::PseudoProperties as PseudoProperties

module HTTP {
  /**
   * A function invocation that causes a redirect response to be sent.
   */
  abstract class RedirectInvocation extends InvokeExpr {
    /** Gets the argument specifying the URL to redirect to. */
    abstract Expr getUrlArgument();

    /** Gets the route handler this redirect occurs in. */
    abstract RouteHandler getRouteHandler();
  }

  /**
   * An expression that sets HTTP response headers.
   *
   * Note that header names are case-insensitive, so this class
   * always normalizes them to lower case: arguments representing
   * header names are expected to be lower case, and similarly
   * results representing header names are always lower case.
   */
  abstract class HeaderDefinition extends DataFlow::Node {
    /**
     * Gets the (lower-case) name of a header set by this definition.
     */
    abstract string getAHeaderName();

    /**
     * Holds if the header with (lower-case) name `headerName` is set to `headerValue`.
     */
    abstract predicate defines(string headerName, string headerValue);

    /**
     * Gets the handler this definition occurs in.
     */
    abstract RouteHandler getRouteHandler();
  }

  /**
   * An expression that sets HTTP response headers implicitly.
   */
  abstract class ImplicitHeaderDefinition extends HeaderDefinition {
    override string getAHeaderName() { this.defines(result, _) }
  }

  /**
   * An expression that sets HTTP response headers explicitly.
   */
  abstract class ExplicitHeaderDefinition extends HeaderDefinition {
    override string getAHeaderName() { this.definesExplicitly(result, _) }

    override predicate defines(string headerName, string headerValue) {
      exists(Expr e |
        this.definesExplicitly(headerName, e) and
        headerValue = e.getStringValue()
      )
    }

    /**
     * Holds if the header with (lower-case) name `headerName` is set to the value of `headerValue`.
     */
    abstract predicate definesExplicitly(string headerName, Expr headerValue);

    /**
     * Returns the expression used to compute the header name.
     */
    abstract Expr getNameExpr();
  }

  /**
   * The name of an HTTP request method, in all-uppercase.
   */
  class RequestMethodName extends string {
    RequestMethodName() {
      this =
        [
          "CHECKOUT", "COPY", "DELETE", "GET", "HEAD", "LOCK", "MERGE", "MKACTIVITY", "MKCOL",
          "MOVE", "M-SEARCH", "NOTIFY", "OPTIONS", "PATCH", "POST", "PURGE", "PUT", "REPORT",
          "SEARCH", "SUBSCRIBE", "TRACE", "UNLOCK", "UNSUBSCRIBE"
        ]
    }

    /**
     * Holds if this kind of HTTP request should be considered free of side effects,
     * such as for `GET` and `HEAD` requests.
     */
    predicate isSafe() {
      this = ["GET", "HEAD", "OPTIONS", "PRI", "PROPFIND", "REPORT", "SEARCH", "TRACE"]
    }

    /**
     * Holds if this kind of HTTP request should not generally be considered free of side effects,
     * such as for `POST` or `PUT` requests.
     */
    predicate isUnsafe() { not this.isSafe() }
  }

  /**
   * An expression whose value is sent as (part of) the body of an HTTP response.
   */
  abstract class ResponseBody extends Expr {
    /**
     * Gets the route handler that sends this expression.
     */
    abstract RouteHandler getRouteHandler();
  }

  /**
   * An expression whose value is included directly (and not, say, via a template)
   * in the body of an HTTP response.
   */
  abstract class ResponseSendArgument extends ResponseBody { }

  /**
   * An expression that sets a cookie in an HTTP response.
   */
  abstract class CookieDefinition extends Expr {
    /**
     * Gets the argument, if any, specifying the raw cookie header.
     */
    Expr getHeaderArgument() { none() }

    /**
     * Gets the argument, if any, specifying the cookie name.
     */
    Expr getNameArgument() { none() }

    /**
     * Gets the argument, if any, specifying the cookie value.
     */
    Expr getValueArgument() { none() }

    /** Gets the route handler that sets this cookie. */
    abstract RouteHandler getRouteHandler();
  }

  /**
   * An expression that sets the `Set-Cookie` header of an HTTP response.
   */
  class SetCookieHeader extends CookieDefinition {
    HeaderDefinition header;

    SetCookieHeader() {
      this = header.asExpr() and
      header.getAHeaderName() = "set-cookie"
    }

    override Expr getHeaderArgument() {
      header.(ExplicitHeaderDefinition).definesExplicitly("set-cookie", result)
    }

    override RouteHandler getRouteHandler() { result = header.getRouteHandler() }
  }

  /**
   * An expression that creates a new server.
   */
  abstract class ServerDefinition extends Expr {
    /**
     * Gets a route handler of the server.
     */
    abstract RouteHandler getARouteHandler();
  }

  /**
   * A callback for handling a request on some route on a server.
   */
  abstract class RouteHandler extends DataFlow::Node {
    /**
     * Gets a header this handler sets.
     *
     * Note that header names are case-insensitive; this predicate always converts
     * header names to lower case.
     */
    abstract HeaderDefinition getAResponseHeader(string name);

    /**
     * Gets a request object originating from this route handler.
     *
     * Use `RequestSource.ref()` to get reference to this request object.
     */
    final Servers::RequestSource getARequestSource() { result.getRouteHandler() = this }

    /**
     * Gets a response object originating from this route handler.
     *
     * Use `ResponseSource.ref()` to get reference to this response object.
     */
    final Servers::ResponseSource getAResponseSource() { result.getRouteHandler() = this }

    /**
     * Gets an expression that contains a request object handled
     * by this handler.
     */
    RequestExpr getARequestExpr() { result.getRouteHandler() = this }

    /**
     * Gets an expression that contains a response object provided
     * by this handler.
     */
    ResponseExpr getAResponseExpr() { result.getRouteHandler() = this }
  }

  /**
   * Holds if there exists a step from `pred` to `succ` for a RouteHandler - beyond the usual steps defined by TypeTracking.
   */
  predicate routeHandlerStep(DataFlow::SourceNode pred, DataFlow::SourceNode succ) {
    // A forwarding call
    DataFlow::functionOneWayForwardingStep(pred.getALocalUse(), succ)
    or
    // a container containing route-handlers.
    exists(HTTP::RouteHandlerCandidateContainer container | pred = container.getRouteHandler(succ))
    or
    // (function (req, res) {}).bind(this);
    exists(DataFlow::PartialInvokeNode call |
      succ = call.getBoundFunction(any(DataFlow::Node n | pred.flowsTo(n)), 0)
    )
    or
    // references to class methods
    succ = CallGraph::callgraphStep(pred, DataFlow::TypeTracker::end())
  }

  /**
   * An expression that sets up a route on a server.
   */
  abstract class RouteSetup extends Expr { }

  /**
   * An expression that may contain a request object.
   */
  abstract class RequestExpr extends Expr {
    /**
     * Gets the route handler that handles this request.
     */
    abstract RouteHandler getRouteHandler();
  }

  /**
   * An expression that may contain a response object.
   */
  abstract class ResponseExpr extends Expr {
    /**
     * Gets the route handler that handles this request.
     */
    abstract RouteHandler getRouteHandler();
  }

  /**
   * Boiler-plate implementation of a `Server` and its associated classes.
   * Made for easily defining new HTTP servers
   */
  module Servers {
    /**
     * A standard server definition.
     */
    abstract class StandardServerDefinition extends ServerDefinition {
      override RouteHandler getARouteHandler() { result.(StandardRouteHandler).getServer() = this }

      private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
        t.start() and
        result = DataFlow::exprNode(this)
        or
        exists(DataFlow::TypeTracker t2 | result = this.ref(t2).track(t2, t))
      }

      /**
       * Holds if `sink` may refer to this server definition.
       */
      predicate flowsTo(Expr sink) { this.ref(DataFlow::TypeTracker::end()).flowsToExpr(sink) }
    }

    /**
     * A standard route handler.
     */
    abstract class StandardRouteHandler extends RouteHandler {
      override HeaderDefinition getAResponseHeader(string name) {
        result.getRouteHandler() = this and
        result.getAHeaderName() = name
      }

      /**
       * Gets the server this route handler is registered on.
       */
      Expr getServer() {
        exists(StandardRouteSetup setup | setup.getARouteHandler() = this |
          result = setup.getServer()
        )
      }
    }

    /**
     * A request source, that is, a data flow node through which
     * a request object enters the flow graph, such as the request
     * parameter of a route handler.
     */
    abstract class RequestSource extends DataFlow::Node {
      /**
       * Gets the route handler that handles this request.
       */
      abstract RouteHandler getRouteHandler();

      /** DEPRECATED. Use `ref().flowsTo()` instead. */
      deprecated predicate flowsTo(DataFlow::Node nd) { this.ref().flowsTo(nd) }

      private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
        t.start() and
        result = this
        or
        exists(DataFlow::TypeTracker t2 | result = this.ref(t2).track(t2, t))
      }

      /** Gets a `SourceNode` that refers to this request object. */
      DataFlow::SourceNode ref() { result = this.ref(DataFlow::TypeTracker::end()) }
    }

    /**
     * A response source, that is, a data flow node through which
     * a response object enters the flow graph, such as the response
     * parameter of a route handler.
     */
    abstract class ResponseSource extends DataFlow::Node {
      /**
       * Gets the route handler that provides this response.
       */
      abstract RouteHandler getRouteHandler();

      /** DEPRECATED. Use `ref().flowsTo()` instead. */
      deprecated predicate flowsTo(DataFlow::Node nd) { this.ref().flowsTo(nd) }

      private DataFlow::SourceNode ref(DataFlow::TypeTracker t) {
        t.start() and
        result = this
        or
        exists(DataFlow::TypeTracker t2 | result = this.ref(t2).track(t2, t))
      }

      /** Gets a `SourceNode` that refers to this response object. */
      DataFlow::SourceNode ref() { result = this.ref(DataFlow::TypeTracker::end()) }
    }

    /**
     * A request expression arising from a request source.
     */
    class StandardRequestExpr extends RequestExpr {
      RequestSource src;

      StandardRequestExpr() { src.ref().flowsTo(DataFlow::valueNode(this)) }

      override RouteHandler getRouteHandler() { result = src.getRouteHandler() }
    }

    /**
     * A response expression arising from a response source.
     */
    class StandardResponseExpr extends ResponseExpr {
      ResponseSource src;

      StandardResponseExpr() { src.ref().flowsTo(DataFlow::valueNode(this)) }

      override RouteHandler getRouteHandler() { result = src.getRouteHandler() }
    }

    /**
     * A standard header definition.
     */
    abstract class StandardHeaderDefinition extends ExplicitHeaderDefinition, DataFlow::ValueNode {
      override MethodCallExpr astNode;

      override predicate definesExplicitly(string headerName, Expr headerValue) {
        headerName = this.getNameExpr().getStringValue().toLowerCase() and
        headerValue = astNode.getArgument(1)
      }

      override Expr getNameExpr() { result = astNode.getArgument(0) }
    }

    /**
     * A standard route setup on a server.
     */
    abstract class StandardRouteSetup extends RouteSetup {
      /**
       * Gets a route handler that is defined by this setup.
       */
      pragma[nomagic]
      abstract DataFlow::SourceNode getARouteHandler();

      /**
       * Gets the server on which this route setup sets up routes.
       */
      abstract Expr getServer();
    }

    /**
     * A parameter containing data received by a NodeJS HTTP server.
     * E.g. `chunk` in: `http.createServer().on('request', (req, res) => req.on("data", (chunk) => ...))`.
     */
    private class ServerRequestDataEvent extends RemoteFlowSource, DataFlow::ParameterNode {
      ServerRequestDataEvent() {
        exists(DataFlow::MethodCallNode mcn, RequestSource req |
          mcn = req.ref().getAMethodCall(EventEmitter::on())
        |
          mcn.getArgument(0).mayHaveStringValue("data") and
          this = mcn.getABoundCallbackParameter(1, 0)
        )
      }

      override string getSourceType() { result = "NodeJS HTTP server data event" }
    }
  }

  /**
   * An access to a user-controlled HTTP request input.
   */
  abstract class RequestInputAccess extends RemoteFlowSource {
    override string getSourceType() { result = "Server request " + this.getKind() }

    /**
     * Gets the route handler whose request input is accessed.
     */
    abstract RouteHandler getRouteHandler();

    /**
     * Gets the kind of the accessed input,
     * Can be one of "parameter", "header", "body", "url", "cookie".
     *
     * Note that this predicate is functional.
     */
    abstract string getKind();

    /**
     * Holds if this part of the request may be controlled by a third party,
     * that is, an agent other than the one who sent the request.
     *
     * This is true for the URL, query parameters, and request body.
     * These can be controlled by a malicious third party in the following scenarios:
     *
     * - The user clicks a malicious link or is otherwise redirected to a malicious URL.
     * - The user visits a web site that initiates a form submission or AJAX request on their behalf.
     *
     * In these cases, the request is technically sent from the user's browser, but
     * the user is not in direct control of the URL or POST body.
     *
     * Headers are never considered third-party controllable by this predicate, although the
     * third party does have some control over the the Referer and Origin headers.
     */
    predicate isThirdPartyControllable() { this.getKind() = ["parameter", "url", "body"] }
  }

  /**
   * An access to a header on an incoming HTTP request.
   */
  abstract class RequestHeaderAccess extends RequestInputAccess {
    /**
     * Gets the lower-case name of an HTTP header from which this input is derived,
     * if this can be determined.
     *
     * When the name of the header is unknown, this has no result.
     */
    abstract string getAHeaderName();
  }

  /**
   * A node that looks like a route setup on a server.
   *
   * This is useful for tasks such as heuristic analyses
   * and exploratory queries.
   */
  abstract class RouteSetupCandidate extends DataFlow::ValueNode {
    /**
     * Gets an expression that contains a route handler of this setup.
     */
    abstract DataFlow::ValueNode getARouteHandlerArg();
  }

  /**
   * A function that looks like a route handler.
   *
   * This is useful for tasks such as heuristic analyses
   * and exploratory queries.
   */
  abstract class RouteHandlerCandidate extends DataFlow::FunctionNode { }

  /**
   * An expression that creates a route handler that parses cookies
   */
  abstract class CookieMiddlewareInstance extends DataFlow::SourceNode {
    /**
     * Gets a secret key used for signed cookies.
     */
    abstract DataFlow::Node getASecretKey();
  }

  /**
   * A key used for signed cookies, viewed as a `CryptographicKey`.
   */
  class CookieCryptographicKey extends CryptographicKey {
    CookieCryptographicKey() { this = any(CookieMiddlewareInstance instance).getASecretKey() }
  }

  /**
   * An object that contains one or more potential route handlers.
   */
  class RouteHandlerCandidateContainer extends DataFlow::Node instanceof RouteHandlerCandidateContainer::Range {
    /**
     * Gets the route handler in this container that is accessed at `access`.
     */
    DataFlow::SourceNode getRouteHandler(DataFlow::SourceNode access) {
      result = super.getRouteHandler(access)
    }
  }

  /**
   * Provides classes for working with objects that may contain one or more route handlers.
   */
  module RouteHandlerCandidateContainer {
    private DataFlow::SourceNode ref(DataFlow::TypeTracker t, RouteHandlerCandidateContainer c) {
      t.start() and result = c
      or
      exists(DataFlow::TypeTracker t2 | result = ref(t2, c).track(t2, t))
    }

    private DataFlow::SourceNode ref(RouteHandlerCandidateContainer c) {
      result = ref(DataFlow::TypeTracker::end(), c)
    }

    /**
     * A container for one or more potential route handlers.
     *
     * Extend this class and implement its abstract member predicates to model additional
     * containers.
     */
    abstract class Range extends DataFlow::SourceNode {
      /**
       * Gets the route handler in this container that is accessed at `access`.
       */
      abstract DataFlow::SourceNode getRouteHandler(DataFlow::SourceNode access);
    }

    /**
     * An object that contains one or more potential route handlers.
     */
    private class ContainerObject extends Range {
      ContainerObject() {
        (
          this instanceof DataFlow::ObjectLiteralNode
          or
          exists(DataFlow::CallNode create | this = create |
            create = DataFlow::globalVarRef("Object").getAMemberCall("create") and
            create.getArgument(0).asExpr() instanceof NullLiteral
          )
        ) and
        exists(RouteHandlerCandidate candidate |
          getAPossiblyDecoratedHandler(candidate).flowsTo(this.getAPropertyWrite().getRhs())
        )
      }

      override DataFlow::SourceNode getRouteHandler(DataFlow::SourceNode access) {
        result instanceof RouteHandlerCandidate and
        exists(DataFlow::PropWrite write, DataFlow::PropRead read |
          access = read and
          ref(this).getAPropertyRead() = read and
          getAPossiblyDecoratedHandler(result).flowsTo(write.getRhs()) and
          write = this.getAPropertyWrite()
        |
          write.getPropertyName() = read.getPropertyName()
          or
          exists(EnumeratedPropName prop | access = prop.getASourceProp())
          or
          read = DataFlow::lvalueNode(any(ForOfStmt stmt).getLValue())
          or
          // for forwarding calls to an element where the key is determined by the request.
          getRequestParameterRead().flowsToExpr(read.getPropertyNameExpr())
        )
      }
    }

    /**
     * Gets a (chained) property-read/method-call on the request parameter of the route-handler `f`.
     */
    private DataFlow::SourceNode getRequestParameterRead() {
      result = any(RouteHandlerCandidate f).getParameter(0)
      or
      result = getRequestParameterRead().getAPropertyRead()
      or
      result = getRequestParameterRead().getAMethodCall()
    }

    /**
     * Gets a node that is either `candidate`, or a call that decorates `candidate`.
     */
    DataFlow::SourceNode getAPossiblyDecoratedHandler(RouteHandlerCandidate candidate) {
      result = candidate
      or
      DataFlow::functionOneWayForwardingStep(candidate, result)
    }

    private string mapValueProp() {
      result = [PseudoProperties::mapValueAll(), PseudoProperties::mapValueUnknownKey()]
    }

    /**
     * A collection that contains one or more route potential handlers.
     */
    private class ContainerCollection extends HTTP::RouteHandlerCandidateContainer::Range,
      DataFlow::NewNode {
      ContainerCollection() {
        this = DataFlow::globalVarRef("Map").getAnInstantiation() and // restrict to Map for now
        exists(DataFlow::Node use |
          DataFlow::SharedTypeTrackingStep::storeStep(use, this, mapValueProp()) and
          use.getALocalSource() instanceof RouteHandlerCandidate
        )
      }

      override DataFlow::SourceNode getRouteHandler(DataFlow::SourceNode access) {
        exists(DataFlow::Node input, string key, DataFlow::Node loadFrom |
          getAPossiblyDecoratedHandler(result).flowsTo(input) and
          DataFlow::SharedTypeTrackingStep::storeStep(input, this, key) and
          ref(this).flowsTo(loadFrom) and
          DataFlow::SharedTypeTrackingStep::loadStep(loadFrom, access,
            [key, PseudoProperties::mapValueAll()])
        )
      }
    }
  }
}
