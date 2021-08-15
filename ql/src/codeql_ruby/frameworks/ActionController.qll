private import codeql_ruby.AST
private import codeql_ruby.Concepts
private import codeql_ruby.controlflow.CfgNodes
private import codeql_ruby.DataFlow
private import codeql_ruby.dataflow.RemoteFlowSources
private import codeql_ruby.ast.internal.Module
private import ActionView

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

  /**
   * Gets a `ActionControllerActionMethod` defined in this class.
   */
  ActionControllerActionMethod getAnAction() { result = this.getAMethod() }
}

/**
 * An instance method defined within an `ActionController` controller class.
 * This may be the target of a route handler, if such a route is defined.
 */
class ActionControllerActionMethod extends Method, HTTP::Server::RequestHandler::Range {
  private ActionControllerControllerClass controllerClass;

  ActionControllerActionMethod() { this = controllerClass.getAMethod() }

  /**
   * Establishes a mapping between a method within the file
   * `<source_prefix>/app/controllers/<subpath>_controller.rb` and the
   * corresponding template file at
   * `<source_prefix>/app/views/<subpath>/<method_name>.html.erb`.
   */
  ErbFile getDefaultTemplateFile() {
    exists(string templatePath, string sourcePrefix, string subPath, string controllerPath |
      controllerPath = this.getLocation().getFile().getAbsolutePath() and
      sourcePrefix = controllerPath.regexpCapture("^(.*)/app/controllers/.*$", 1) and
      controllerPath = sourcePrefix + "/app/controllers/" + subPath + "_controller.rb" and
      templatePath = sourcePrefix + "/app/views/" + subPath + "/" + this.getName() + ".html.erb"
    |
      result.getAbsolutePath() = templatePath
    )
  }

  // params come from `params` method rather than a method parameter
  override Parameter getARoutedParameter() { none() }

  override string getFramework() { result = "ActionController" }

  /** Gets a call to render from within this method. */
  RenderCall getARenderCall() { result.getParent+() = this }

  // TODO: model the implicit render call when a path through the method does
  // not end at an explicit render or redirect
  /** Gets the controller class containing this method. */
  ActionControllerControllerClass getControllerClass() { result = controllerClass }
}

// A method call with a `self` receiver from within a controller class
private class ActionControllerContextCall extends MethodCall {
  private ActionControllerControllerClass controllerClass;

  ActionControllerContextCall() {
    this.getReceiver() instanceof Self and
    this.getEnclosingModule() = controllerClass
  }

  ActionControllerControllerClass getControllerClass() { result = controllerClass }
}

/**
 * A call to the `params` method to fetch the request parameters.
 */
abstract class ParamsCall extends MethodCall {
  ParamsCall() { this.getMethodName() = "params" }
}

/**
 * A `RemoteFlowSource::Range` to represent accessing the
 * ActionController parameters available via the `params` method.
 */
class ParamsSource extends RemoteFlowSource::Range {
  ParamsCall call;

  ParamsSource() { this.asExpr().getExpr() = call }

  override string getSourceType() { result = "ActionController::Metal#params" }
}

// A call to `params` from within a controller.
private class ActionControllerParamsCall extends ActionControllerContextCall, ParamsCall { }

// A call to `render_to` from within a controller.
private class ActionControllerRenderToCall extends ActionControllerContextCall, RenderToCall { }

// A call to `html_safe` from within a controller.
private class ActionControllerHtmlSafeCall extends HtmlSafeCall {
  ActionControllerHtmlSafeCall() { this.getEnclosingModule() instanceof ActionControllerControllerClass }
}

/**
 * A call to the `redirect_to` method, used in an action to redirect to a
 * specific URL/path or to a different action in this controller.
 */
class RedirectToCall extends ActionControllerContextCall {
  RedirectToCall() { this.getMethodName() = "redirect_to" }

  /** Gets the `Expr` representing the URL to redirect to, if any */
  Expr getRedirectUrl() { result = this.getArgument(0) }

  /** Gets the `ActionControllerActionMethod` to redirect to, if any */
  ActionControllerActionMethod getRedirectActionMethod() {
    exists(string methodName |
      methodName = this.getKeywordArgument("action").(StringlikeLiteral).getValueText() and
      methodName = result.getName() and
      result.getEnclosingModule() = this.getControllerClass()
    )
  }
}

/**
 * A `SetterMethodCall` that assigns a value to the `response_body`.
 */
class ResponseBodySetterCall extends SetterMethodCall {
  ResponseBodySetterCall() { this.getMethodName() = "response_body=" }
}

/**
 * A method in an `ActionController` class that is accessible from within a view as a helper method.
 */
class ActionControllerHelperMethod extends Method {
  private ActionControllerControllerClass controllerClass;

  ActionControllerHelperMethod() {
    this.getEnclosingModule() = controllerClass and
    exists(MethodCall helperMethodMarker |
      helperMethodMarker.getMethodName() = "helper_method" and
      helperMethodMarker.getAnArgument().(StringlikeLiteral).getValueText() = this.getName() and
      helperMethodMarker.getEnclosingModule() = controllerClass
    )
  }

  /** Gets the class containing this helper method. */
  ActionControllerControllerClass getControllerClass() { result = controllerClass }
}
