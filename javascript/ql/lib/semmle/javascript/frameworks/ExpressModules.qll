/**
 * Models of npm modules that are used with Express servers.
 */

import javascript
import semmle.javascript.frameworks.HTTP

module ExpressLibraries {
  /**
   * Holds if `headerName` and `headerValue` corresponds to a default "X-Frame-Options" HTTP header.
   */
  private predicate xFrameOptionsDefaultImplicitHeaderDefinition(
    string headerName, string headerValue
  ) {
    headerName = "x-frame-options" and headerValue = "DENY"
  }

  /**
   * A header produced by a route handler of the "x-frame-options" module.
   */
  class XFrameOptionsRouteHandlerHeader extends Http::ImplicitHeaderDefinition instanceof XFrameOptionsRouteHandler
  {
    override predicate defines(string headerName, string headerValue) {
      xFrameOptionsDefaultImplicitHeaderDefinition(headerName, headerValue)
    }

    override Http::RouteHandler getRouteHandler() { result = this }
  }

  /**
   * A route handler from the "x-frame-options" module.
   */
  class XFrameOptionsRouteHandler extends Http::RouteHandler {
    XFrameOptionsRouteHandler() {
      this = DataFlow::moduleImport("x-frame-options").getAnInvocation()
    }

    override Http::HeaderDefinition getAResponseHeader(string name) {
      name = this.(XFrameOptionsRouteHandlerHeader).getAHeaderName() and
      result = this
    }
  }

  /**
   * A header produced by a route handler of the "frameguard" module.
   */
  class FrameGuardRouteHandlerHeader extends Http::ImplicitHeaderDefinition instanceof FrameGuardRouteHandler
  {
    override predicate defines(string headerName, string headerValue) {
      xFrameOptionsDefaultImplicitHeaderDefinition(headerName, headerValue)
    }

    override Http::RouteHandler getRouteHandler() { result = this }
  }

  /**
   * A route handler from the "frameguard" module.
   */
  class FrameGuardRouteHandler extends Http::RouteHandler {
    FrameGuardRouteHandler() { this = DataFlow::moduleImport("frameguard").getAnInvocation() }

    override Http::HeaderDefinition getAResponseHeader(string name) {
      name = this.(FrameGuardRouteHandlerHeader).getAHeaderName() and
      result = this
    }
  }

  /**
   * A header produced by a route handler of the "helmet" module.
   */
  class HelmetRouteHandlerHeader extends Http::ImplicitHeaderDefinition instanceof HelmetRouteHandler
  {
    override predicate defines(string headerName, string headerValue) {
      xFrameOptionsDefaultImplicitHeaderDefinition(headerName, headerValue)
    }

    override Http::RouteHandler getRouteHandler() { result = this }
  }

  /**
   * A route handler from the "helmet" module.
   */
  class HelmetRouteHandler extends Http::RouteHandler {
    HelmetRouteHandler() {
      exists(DataFlow::ModuleImportNode m | "helmet" = m.getPath() |
        this = m.getAnInvocation() or
        this = m.getAMemberInvocation("frameguard")
      )
    }

    override Http::HeaderDefinition getAResponseHeader(string name) {
      name = this.(HelmetRouteHandlerHeader).getAHeaderName() and
      result = this
    }
  }

  /**
   * Provides classes for working with the `express-session` package (https://github.com/expressjs/session);
   */
  module ExpressSession {
    private DataFlow::SourceNode expressSession() {
      result = DataFlow::moduleImport("express-session")
    }

    /**
     * A call that creates an `express-session` middleware instance.
     */
    class MiddlewareInstance extends DataFlow::InvokeNode, Http::CookieMiddlewareInstance {
      MiddlewareInstance() { this = expressSession().getACall() }

      /**
       * Gets the expression for property `name` of the options object of this call.
       */
      DataFlow::Node getOption(string name) { result = this.getOptionArgument(0, name) }

      override DataFlow::Node getASecretKey() {
        exists(DataFlow::Node secret | secret = this.getOption("secret") |
          if exists(DataFlow::ArrayCreationNode arr | arr.flowsTo(secret))
          then result = any(DataFlow::ArrayCreationNode arr | arr.flowsTo(secret)).getAnElement()
          else result = secret
        )
      }
    }
  }

  /**
   * Provides classes for working with the `cookie-parser` package (https://github.com/expressjs/cookie-parser);
   */
  module CookieParser {
    private DataFlow::SourceNode cookieParser() { result = DataFlow::moduleImport("cookie-parser") }

    /**
     * A call that creates a `cookie-parser` middleware instance.
     */
    class MiddlewareInstance extends DataFlow::InvokeNode, Http::CookieMiddlewareInstance {
      MiddlewareInstance() { this = cookieParser().getACall() }

      /**
       * Gets the expression for property `name` of the options object of this call.
       */
      DataFlow::Node getOption(string name) { result = this.getOptionArgument(1, name) }

      override DataFlow::Node getASecretKey() {
        exists(DataFlow::Node arg0 | arg0 = this.getArgument(0) |
          if exists(DataFlow::ArrayCreationNode arr | arr.flowsTo(arg0))
          then result = any(DataFlow::ArrayCreationNode arr | arr.flowsTo(arg0)).getAnElement()
          else result = arg0
        )
      }
    }
  }

  /**
   * Provides classes for working with the `cookie-session` package (https://github.com/expressjs/cookie-session);
   */
  module CookieSession {
    private DataFlow::SourceNode cookieSession() {
      result = DataFlow::moduleImport("cookie-session")
    }

    /**
     * A call that creates a `cookie-session` middleware instance.
     */
    class MiddlewareInstance extends DataFlow::InvokeNode, Http::CookieMiddlewareInstance {
      MiddlewareInstance() { this = cookieSession().getACall() }

      /**
       * Gets the expression for property `name` of the options object of this call.
       */
      DataFlow::Node getOption(string name) { result = this.getOptionArgument(0, name) }

      override DataFlow::Node getASecretKey() {
        result = this.getOption("secret")
        or
        exists(DataFlow::ArrayCreationNode keys |
          keys.flowsTo(this.getOption("keys")) and
          result = keys.getAnElement()
        )
      }
    }
  }

  /**
   * An instance of the Express `body-parser` middleware.
   */
  class BodyParser extends DataFlow::InvokeNode {
    string kind;

    BodyParser() {
      this = DataFlow::moduleImport("body-parser").getACall() and kind = "json"
      or
      exists(string moduleName |
        (moduleName = "body-parser" or moduleName = "express") and
        (kind = "json" or kind = "urlencoded") and
        this = DataFlow::moduleMember(moduleName, kind).getACall()
      )
    }

    /**
     * Holds if this is a JSON body parser.
     */
    predicate isJson() { kind = "json" }

    /**
     * Holds if this is a URL-encoded body parser.
     */
    predicate isUrlEncoded() { kind = "urlencoded" }

    /**
     * Holds if this is an extended URL-encoded body parser.
     *
     * The extended URL-encoding allows for nested objects, like JSON.
     */
    predicate isExtendedUrlEncoded() {
      kind = "urlencoded" and
      not this.getOptionArgument(0, "extended").mayHaveBooleanValue(false)
    }

    /**
     * Holds if this parses the input as JSON or extended URL-encoding, resulting
     * in user-controlled objects (as opposed to user-controlled strings).
     */
    predicate producesUserControlledObjects() { this.isJson() or this.isExtendedUrlEncoded() }
  }
}

/**
 * Provides classes for working with the `express-fileupload` package (https://github.com/richardgirges/express-fileupload);
 */
module FileUpload {
  /** Gets a data flow node referring to `req.files`. */
  private DataFlow::SourceNode filesRef(Express::RequestSource req, DataFlow::TypeTracker t) {
    t.start() and
    result = req.ref().getAPropertyRead("files")
    or
    exists(DataFlow::TypeTracker t2 | result = filesRef(req, t2).track(t2, t))
  }

  /**
   * A call to `req.files.<name>.mv`
   */
  class Move extends FileSystemWriteAccess, DataFlow::MethodCallNode {
    Move() {
      exists(DataFlow::moduleImport("express-fileupload")) and
      this = filesRef(_, DataFlow::TypeTracker::end()).getAPropertyRead().getAMethodCall("mv")
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }

    override DataFlow::Node getADataNode() { none() }
  }
}
