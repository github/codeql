/**
 * Models of npm modules that are used with Express servers.
 */

import javascript
private import semmle.javascript.frameworks.HTTP
private import semmle.javascript.frameworks.Express
private import semmle.javascript.security.dataflow.Xss

/**
 * Models of the express-validator npm module.
 */
module ExpressValidator {
  /**
   * The middleware instance that is used to validate the request.
   */
  class MiddlewareInstance extends DataFlow::InvokeNode {
    private string validator;

    MiddlewareInstance() {
      exists(DataFlow::SourceNode middleware |
        (
          // query('search').notEmpty().escape()
          middleware = DataFlow::moduleMember("express-validator", ["query", "param"]).getACall() and
          validator = "parameter"
          or
          // body('search').notEmpty().escape()
          middleware = DataFlow::moduleMember("express-validator", "body").getACall() and
          validator = "body"
          or
          // cookie('search').notEmpty().escape()
          middleware = DataFlow::moduleMember("express-validator", "cookie").getACall() and
          validator = "cookie"
          or
          // header('search').notEmpty().escape()
          middleware = DataFlow::moduleMember("express-validator", "header").getACall() and
          validator = "header"
        ) and
        isSafe(middleware)
      |
        this = middleware
      )
    }

    /**
     * Gets the name iof the parameter that is safe.
     */
    string getSafeParameterName() { this.getArgument(0).mayHaveStringValue(result) }

    /**
     * Gets the type of the validator (parameter, body, etc)
     */
    string getValidatorType() { result = validator }

    /**
     * Gets the route handler that is validated.
     */
    Express::RouteHandler getRouteHandler() {
      exists(Express::RouteSetup route |
        this.getAstNode().getParent*() = route.getARouteHandlerNode().getAstNode()
      |
        result = route.getLastRouteHandlerNode()
      )
    }

    /**
     * Gets the parameter that is validated and is secure
     */
    DataFlow::Node getSecureRequestInputAccess() {
      exists(Express::RequestInputAccess node |
        // Hook up to the parameter that is validated
        this.getRouteHandler() = node.getRouteHandler() and
        // Check the kind of the parameter is the same as the safely escaped parameter
        node.getKind() = this.getValidatorType() and
        // Check if the PropertyAccess is getSafeParameterName()
        node.(DataFlow::PropRead).getPropertyName() = this.getSafeParameterName() and
        node.isUserControlledObject()
      |
        result = node
      )
    }
  }

  /**
   * If the `query/body/cookie/header` functions are called, we want to check if one of the
   * chaining method calls is a sanitizer.
   *
   * If a non-sanitizing functions is called, we want to recursively check if the parent is safe
   */
  private predicate isSafe(DataFlow::SourceNode node) {
    // Sanitizers
    exists(node.getAChainedMethodCall(["escape", "isEmail", "isIn", "isInt"]))
    or
    // Non-sanitizing chained calls
    exists(DataFlow::SourceNode builder |
      builder =
        node.getAChainedMethodCall([
            "notEmpty", "exists", "isArray", "isObject", "isString", "isULID",
          ]) and
      isSafe(builder)
    )
  }

  /**
   * The sanitizers for `express-validator` validated requests.
   *
   * These are a list of source nodes that are automatically sanitized by the
   * express-validator library.
   */
  class ExpressValidatorSanitizer extends DataFlow::Node {
    ExpressValidatorSanitizer() {
      exists(ExpressValidator::MiddlewareInstance middleware |
        this = middleware.getSecureRequestInputAccess()
      )
    }
  }
}
