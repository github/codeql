/**
 * Provides classes for working with [Sails](https://sailsjs.com/) applications.
 */

import javascript
import semmle.javascript.frameworks.HTTP
private import DataFlow

/**
 * Provides classes for working with [Sails](https://sailsjs.com/) applications.
 */
module Sails {
  /**
   * A Sails Action2 action object exported from a module.
   *
   * For example:
   *
   * ```javascript
   * module.exports = {
   *   inputs: { filename: { type: "string" } },
   *   fn(inputs, exits) { ... }
   * };
   * ```
   */
  private class Action2Action extends ObjectExpr {
    Action2Action() {
      exists(Module mod, DataFlow::FunctionNode fn |
        mod.getABulkExportedNode().getALocalSource().asExpr() = this and
        this.getFile().getRelativePath().regexpMatch("(^|.*/)api/controllers/.*") and
        this.getPropertyByName("inputs").getInit() instanceof ObjectExpr and
        fn = DataFlow::valueNode(this.getPropertyByName("fn").getInit()).getAFunctionValue()
      )
    }

    /**
     * Gets the `fn` function that handles the action.
     */
    DataFlow::FunctionNode getFunction() {
      result = DataFlow::valueNode(this.getPropertyByName("fn").getInit()).getAFunctionValue()
    }

    /**
     * Gets the name of an input declared by this action.
     */
    string getADeclaredInputName() {
      result = this.getPropertyByName("inputs").getInit().(ObjectExpr).getAProperty().getName()
    }
  }

  /**
   * A Sails Action2 handler function.
   */
  private class Action2RouteHandler extends Http::Servers::StandardRouteHandler,
    DataFlow::FunctionNode
  {
    Action2Action action;

    Action2RouteHandler() { this = action.getFunction() }

    /**
     * Gets the parameter of the action handler that contains the validated action inputs.
     */
    DataFlow::ParameterNode getInputsParameter() { result = this.getParameter(0) }

    /**
     * Gets the name of an input declared by this action.
     */
    string getADeclaredInputName() { result = action.getADeclaredInputName() }
  }

  /**
   * An access to a user-controlled Sails Action2 input.
   */
  private class Action2InputAccess extends Http::RequestInputAccess {
    Action2RouteHandler rh;

    Action2InputAccess() {
      this = rh.getInputsParameter().getAPropertyRead(rh.getADeclaredInputName())
    }

    override Action2RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = "parameter" }
  }
}
