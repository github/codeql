private import codeql_ruby.AST
private import codeql_ruby.Concepts
private import codeql_ruby.controlflow.CfgNodes
private import codeql_ruby.DataFlow
private import codeql_ruby.dataflow.RemoteFlowSources
private import codeql_ruby.ast.internal.Module

private class ActionControllerBaseAccess extends ConstantReadAccess {
  ActionControllerBaseAccess() {
    this.getName() = "Base" and
    this.getScopeExpr().(ConstantAccess).getName() = "ActionController"
  }
}

// ApplicationController extends ActionController::Base, but we
// treat it separately in case the ApplicationController definition
// is not in the database
private class ApplicationControllerAccess extends ConstantReadAccess {
  ApplicationControllerAccess() { this.getName() = "ApplicationController" }
}

// TODO: Less clumsy name for this?
/**
 * A `ClassDeclaration` for a class that extends `ActionController::Base`.
 * For example,
 *
 * ```rb
 * class FooController < ActionController::Base
 *   def delete_handler
 *     uid = params[:id]
 *     User.delete_all("id = ?", uid)
 *   end
 * end
 * ```
 */
class ActionControllerControllerClass extends ClassDeclaration {
  ActionControllerControllerClass() {
    // class FooController < ActionController::Base
    this.getSuperclassExpr() instanceof ActionControllerBaseAccess
    or
    // class FooController < ApplicationController
    this.getSuperclassExpr() instanceof ApplicationControllerAccess
    or
    // class BarController < FooController
    exists(ActionControllerControllerClass other |
      other.getModule() = resolveScopeExpr(this.getSuperclassExpr())
    )
  }
}

/**
 * A call to the `params` method within the context of an
 * `ActionControllerControllerClass`. For example, the `params` call in:
 *
 * ```rb
 * class FooController < ActionController::Base
 *   def delete_handler
 *     uid = params[:id]
 *     User.delete_all("id = ?", uid)
 *   end
 * end
 * ```
 */
class ActionControllerParamsCall extends MethodCall {
  private ActionControllerControllerClass controllerClass;

  ActionControllerParamsCall() {
    this.getMethodName() = "params" and
    this.getReceiver() instanceof Self and
    this.getEnclosingModule() = controllerClass
  }

  ActionControllerControllerClass getControllerClass() { result = controllerClass }
}

/**
 * A `RemoteFlowSource::Range` to represent accessing the Action Controller
 * parameters available to a controller via the `params` method.
 */
class ActionControllerParamsSource extends RemoteFlowSource::Range {
  ActionControllerParamsCall call;

  ActionControllerParamsSource() { this.asExpr().getExpr() = call }

  // TODO: what to use here?
  override string getSourceType() { result = "ActionController::Metal#params" }
}
