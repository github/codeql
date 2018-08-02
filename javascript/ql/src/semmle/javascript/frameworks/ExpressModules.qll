/**
 * Models of npm modules that are used with Express servers.
 */
import javascript
import semmle.javascript.frameworks.HTTP

module ExpressLibraries {

  /**
  * Holds if `headerName` and `headerValue` corresponds to a default "X-Frame-Options" HTTP header.
  */
  private predicate xFrameOptionsDefaultImplicitHeaderDefinition(string headerName, string headerValue) {
    headerName = "x-frame-options" and headerValue = "DENY"
  }

  /**
   * Header produced by a route handler of the "x-frame-options" module.
   */
  class XFrameOptionsRouteHandlerHeader extends HTTP::ImplicitHeaderDefinition {

    XFrameOptionsRouteHandlerHeader() {
      this instanceof XFrameOptionsRouteHandler
    }

    override predicate defines(string headerName, string headerValue) {
      xFrameOptionsDefaultImplicitHeaderDefinition(headerName, headerValue)
    }

    override HTTP::RouteHandler getRouteHandler() {
      result = this
    }
  }

  /**
   * Route handler from the "x-frame-options" module.
   */
  class XFrameOptionsRouteHandler extends HTTP::RouteHandler {
    XFrameOptionsRouteHandler() {
      this = DataFlow::moduleImport("x-frame-options").getAnInvocation()
    }

    override HTTP::HeaderDefinition getAResponseHeader(string name) {
      name = this.(XFrameOptionsRouteHandlerHeader).getAHeaderName() and
      result = this
    }

  }


  /**
   * Header produced by a route handler of the "frameguard" module.
   */
  class FrameGuardRouteHandlerHeader extends HTTP::ImplicitHeaderDefinition {

    FrameGuardRouteHandlerHeader() {
      this instanceof FrameGuardRouteHandler
    }

    override predicate defines(string headerName, string headerValue) {
      xFrameOptionsDefaultImplicitHeaderDefinition(headerName, headerValue)
    }

    override HTTP::RouteHandler getRouteHandler() {
      result = this
    }
  }

  /**
   * Route handler from the "frameguard" module.
   */
  class FrameGuardRouteHandler extends HTTP::RouteHandler {
    FrameGuardRouteHandler() {
      this = DataFlow::moduleImport("frameguard").getAnInvocation()
    }

    override HTTP::HeaderDefinition getAResponseHeader(string name) {
      name = this.(FrameGuardRouteHandlerHeader).getAHeaderName() and
      result = this
    }

  }


  /**
   * Header produced by a route handler of the "helmet" module.
   */
  class HelmetRouteHandlerHeader extends HTTP::ImplicitHeaderDefinition {

    HelmetRouteHandlerHeader() {
      this instanceof HelmetRouteHandler
    }

    override predicate defines(string headerName, string headerValue) {
      xFrameOptionsDefaultImplicitHeaderDefinition(headerName, headerValue)
    }

    override HTTP::RouteHandler getRouteHandler() {
      result = this
    }
  }

  /**
   * Route handler from the "helmet" module.
   */
  class HelmetRouteHandler extends HTTP::RouteHandler {
    HelmetRouteHandler() {
      exists (DataFlow::ModuleImportNode m | "helmet" = m.getPath() |
        this = m.getAnInvocation()  or
        this = m.getAMemberInvocation("frameguard")
      )
    }

    override HTTP::HeaderDefinition getAResponseHeader(string name) {
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
    class MiddlewareInstance extends DataFlow::InvokeNode, HTTP::CookieMiddlewareInstance {

      MiddlewareInstance() {
        this = expressSession().getACall()
      }

      /**
       * Gets the expression for property `name` of the options object of this call.
       */
      DataFlow::Node getOption(string name) {
        result = getOptionArgument(0, name)
      }

      override DataFlow::Node getASecretKey() {
        exists (DataFlow::Node secret | secret = getOption("secret") |
          if exists(DataFlow::ArrayLiteralNode arr | arr.flowsTo(secret)) then
            result = any (DataFlow::ArrayLiteralNode arr | arr.flowsTo(secret)).getAnElement()
          else
            result = secret
        )
      }

    }

  }

  /**
   * Provides classes for working with the `cookie-parser` package (https://github.com/expressjs/cookie-parser);
   */
  module CookieParser {

    private DataFlow::SourceNode cookieParser() {
      result = DataFlow::moduleImport("cookie-parser")
    }

    /**
     * A call that creates a `cookie-parser` middleware instance.
     */
    class MiddlewareInstance extends DataFlow::InvokeNode, HTTP::CookieMiddlewareInstance {

      MiddlewareInstance() {
        this = cookieParser().getACall()
      }

      /**
       * Gets the expression for property `name` of the options object of this call.
       */
      DataFlow::Node getOption(string name) {
        result = getOptionArgument(1, name)
      }

      override DataFlow::Node getASecretKey() {
        exists (DataFlow::Node arg0 | arg0 = getArgument(0) |
          if exists(DataFlow::ArrayLiteralNode arr | arr.flowsTo(arg0)) then
            result = any (DataFlow::ArrayLiteralNode arr | arr.flowsTo(arg0)).getAnElement()
          else
            result = arg0
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
    class MiddlewareInstance extends DataFlow::InvokeNode, HTTP::CookieMiddlewareInstance {

      MiddlewareInstance() {
        this = cookieSession().getACall()
      }

      /**
       * Gets the expression for property `name` of the options object of this call.
       */
      DataFlow::Node getOption(string name) {
        result = getOptionArgument(0, name)
      }

      override DataFlow::Node getASecretKey() {
        result = getOption("secret") or
        exists (DataFlow::ArrayLiteralNode keys |
          keys.flowsTo(getOption("keys")) and
          result = keys.getAnElement()
        )
      }

    }

  }

}
