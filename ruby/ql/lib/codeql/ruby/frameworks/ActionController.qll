/**
 * Provides modeling for the `ActionController` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.ast.internal.Module
private import codeql.ruby.ApiGraphs
private import ActionView
private import codeql.ruby.frameworks.ActionDispatch
private import codeql.ruby.Concepts

/**
 * A `ClassDeclaration` for a class that extends `ActionController::Base`.
 * For example,
 *
 * ```rb
 * class FooController < ActionController::Base
 *   def delete_handler
 *     uid = params[:id]
 *     User.delete_by("id = ?", uid)
 *   end
 * end
 * ```
 */
class ActionControllerControllerClass extends ClassDeclaration {
  ActionControllerControllerClass() {
    this.getSuperclassExpr() =
      [
        API::getTopLevelMember("ActionController").getMember("Base"),
        // In Rails applications `ApplicationController` typically extends `ActionController::Base`, but we
        // treat it separately in case the `ApplicationController` definition is not in the database.
        API::getTopLevelMember("ApplicationController")
      ].getASubclass().getAUse().asExpr().getExpr()
  }

  /**
   * Gets a `ActionControllerActionMethod` defined in this class.
   */
  ActionControllerActionMethod getAnAction() { result = this.getAMethod() }
}

/**
 * A public instance method defined within an `ActionController` controller class.
 * This may be the target of a route handler, if such a route is defined.
 */
class ActionControllerActionMethod extends Method, HTTP::Server::RequestHandler::Range {
  private ActionControllerControllerClass controllerClass;

  ActionControllerActionMethod() { this = controllerClass.getAMethod() and not this.isPrivate() }

  /**
   * Establishes a mapping between a method within the file
   * `<sourcePrefix>app/controllers/<subpath>_controller.rb` and the
   * corresponding template file at
   * `<sourcePrefix>app/views/<subpath>/<method_name>.html.erb`.
   */
  ErbFile getDefaultTemplateFile() {
    controllerTemplateFile(this.getControllerClass(), result) and
    result.getBaseName() = this.getName() + ".html.erb"
  }

  // params come from `params` method rather than a method parameter
  override Parameter getARoutedParameter() { none() }

  override string getFramework() { result = "ActionController" }

  /** Gets a call to render from within this method. */
  RenderCall getARenderCall() { result.getParent+() = this }

  /**
   * Gets the controller class containing this method.
   */
  ActionControllerControllerClass getControllerClass() {
    // TODO: model the implicit render call when a path through the method does
    // not end at an explicit render or redirect
    result = controllerClass
  }

  /**
   * Gets a route to this handler, if one exists.
   * May return multiple results.
   */
  ActionDispatch::Route getARoute() {
    exists(string name |
      isRoute(result, name, controllerClass) and
      isActionControllerMethod(this, name, controllerClass)
    )
  }
}

pragma[nomagic]
private predicate isRoute(
  ActionDispatch::Route route, string name, ActionControllerControllerClass controllerClass
) {
  route.getController() + "_controller" =
    ActionDispatch::underscore(namespaceDeclaration(controllerClass)) and
  name = route.getAction()
}

// A method call with a `self` receiver from within a controller class
private class ActionControllerContextCall extends MethodCall {
  private ActionControllerControllerClass controllerClass;

  ActionControllerContextCall() {
    this.getReceiver() instanceof SelfVariableAccess and
    this.getEnclosingModule() = controllerClass
  }

  /**
   * Gets the controller class containing this method.
   */
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
class ParamsSource extends HTTP::Server::RequestInputAccess::Range {
  ParamsSource() { this.asExpr().getExpr() instanceof ParamsCall }

  override string getSourceType() { result = "ActionController::Metal#params" }
}

/**
 * A call to the `cookies` method to fetch the request parameters.
 */
abstract class CookiesCall extends MethodCall {
  CookiesCall() { this.getMethodName() = "cookies" }
}

/**
 * A `RemoteFlowSource::Range` to represent accessing the
 * ActionController parameters available via the `cookies` method.
 */
class CookiesSource extends HTTP::Server::RequestInputAccess::Range {
  CookiesSource() { this.asExpr().getExpr() instanceof CookiesCall }

  override string getSourceType() { result = "ActionController::Metal#cookies" }
}

// A call to `cookies` from within a controller.
private class ActionControllerCookiesCall extends ActionControllerContextCall, CookiesCall { }

// A call to `params` from within a controller.
private class ActionControllerParamsCall extends ActionControllerContextCall, ParamsCall { }

// A call to `render` from within a controller.
private class ActionControllerRenderCall extends ActionControllerContextCall, RenderCall { }

// A call to `render_to` from within a controller.
private class ActionControllerRenderToCall extends ActionControllerContextCall, RenderToCall { }

// A call to `html_safe` from within a controller.
private class ActionControllerHtmlSafeCall extends HtmlSafeCall {
  ActionControllerHtmlSafeCall() {
    this.getEnclosingModule() instanceof ActionControllerControllerClass
  }
}

// A call to `html_escape` from within a controller.
private class ActionControllerHtmlEscapeCall extends HtmlEscapeCall {
  ActionControllerHtmlEscapeCall() {
    this.getEnclosingModule() instanceof ActionControllerControllerClass
  }
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
      this.getKeywordArgument("action").getConstantValue().isStringlikeValue(methodName) and
      methodName = result.getName() and
      result.getEnclosingModule() = this.getControllerClass()
    )
  }
}

/**
 * A call to the `redirect_to` method, as an `HttpRedirectResponse`.
 */
class ActionControllerRedirectResponse extends HTTP::Server::HttpRedirectResponse::Range {
  RedirectToCall redirectToCall;

  ActionControllerRedirectResponse() { this.asExpr().getExpr() = redirectToCall }

  override DataFlow::Node getBody() { none() }

  override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

  override string getMimetypeDefault() { none() }

  override DataFlow::Node getRedirectLocation() {
    result.asExpr().getExpr() = redirectToCall.getRedirectUrl()
  }
}

pragma[nomagic]
private predicate isActionControllerMethod(Method m, string name, ActionControllerControllerClass c) {
  m.getName() = name and
  m.getEnclosingModule() = c
}

pragma[nomagic]
private predicate actionControllerHasHelperMethodCall(ActionControllerControllerClass c, string name) {
  exists(MethodCall mc |
    mc.getMethodName() = "helper_method" and
    mc.getAnArgument().getConstantValue().isStringlikeValue(name) and
    mc.getEnclosingModule() = c
  )
}

/**
 * A method in an `ActionController` class that is accessible from within a
 * Rails view as a helper method. For instance, in:
 *
 * ```rb
 * class FooController < ActionController::Base
 *   helper_method :logged_in?
 *   def logged_in?
 *     @current_user != nil
 *   end
 * end
 * ```
 *
 * the `logged_in?` method is a helper method.
 * See also https://api.rubyonrails.org/classes/AbstractController/Helpers/ClassMethods.html#method-i-helper_method
 */
class ActionControllerHelperMethod extends Method {
  private ActionControllerControllerClass controllerClass;

  ActionControllerHelperMethod() {
    exists(string name |
      isActionControllerMethod(this, name, controllerClass) and
      actionControllerHasHelperMethodCall(controllerClass, name)
    )
  }

  /** Gets the class containing this helper method. */
  ActionControllerControllerClass getControllerClass() { result = controllerClass }
}

/**
 * Gets an `ActionControllerControllerClass` associated with the given `ErbFile`
 * according to Rails path conventions.
 * For instance, a template file at `app/views/foo/bar/baz.html.erb` will be
 * mapped to a controller class in `app/controllers/foo/bar/baz_controller.rb`,
 * if such a controller class exists.
 */
ActionControllerControllerClass getAssociatedControllerClass(ErbFile f) {
  // There is a direct mapping from template file to controller class
  controllerTemplateFile(result, f)
  or
  // The template `f` is a partial, and it is rendered from within another
  // template file, `fp`. In this case, `f` inherits the associated
  // controller classes from `fp`.
  f.isPartial() and
  exists(RenderCall r, ErbFile fp |
    r.getLocation().getFile() = fp and
    r.getTemplateFile() = f and
    result = getAssociatedControllerClass(fp)
  )
}

// TODO: improve layout support, e.g. for `layout` method
// https://guides.rubyonrails.org/layouts_and_rendering.html
/**
 * Holds if `templatesFile` is a viable file "belonging" to the given
 * `ActionControllerControllerClass`, according to Rails conventions.
 *
 * This handles mappings between controllers in `app/controllers/`, and
 * templates in `app/views/` and `app/views/layouts/`.
 */
predicate controllerTemplateFile(ActionControllerControllerClass cls, ErbFile templateFile) {
  exists(string templatesPath, string sourcePrefix, string subPath, string controllerPath |
    controllerPath = cls.getLocation().getFile().getRelativePath() and
    templatesPath = templateFile.getParentContainer().getRelativePath() and
    // `sourcePrefix` is either a prefix path ending in a slash, or empty if
    // the rails app is at the source root
    sourcePrefix = [controllerPath.regexpCapture("^(.*/)app/controllers/(?:.*?)/(?:[^/]*)$", 1), ""] and
    controllerPath = sourcePrefix + "app/controllers/" + subPath + "_controller.rb" and
    (
      templatesPath = sourcePrefix + "app/views/" + subPath or
      templateFile.getRelativePath().matches(sourcePrefix + "app/views/layouts/" + subPath + "%")
    )
  )
}

/**
 * A call to either `skip_forgery_protection` or
 * `skip_before_action :verify_authenticity_token` to disable CSRF authenticity
 * token protection.
 */
class ActionControllerSkipForgeryProtectionCall extends CSRFProtectionSetting::Range {
  ActionControllerSkipForgeryProtectionCall() {
    exists(MethodCall call | call = this.asExpr().getExpr() |
      call.getMethodName() = "skip_forgery_protection"
      or
      call.getMethodName() = "skip_before_action" and
      call.getAnArgument().getConstantValue().isStringlikeValue("verify_authenticity_token")
    )
  }

  override boolean getVerificationSetting() { result = false }
}

/**
 * A call to `protect_from_forgery`.
 */
private class ActionControllerProtectFromForgeryCall extends CSRFProtectionSetting::Range {
  private ActionControllerContextCall callExpr;

  ActionControllerProtectFromForgeryCall() {
    callExpr = this.asExpr().getExpr() and
    callExpr.getMethodName() = "protect_from_forgery"
  }

  private string getWithValueText() {
    result = callExpr.getKeywordArgument("with").getConstantValue().getSymbol()
  }

  // Calls without `with: :exception` can allow for bypassing CSRF protection
  // in some scenarios.
  override boolean getVerificationSetting() {
    if this.getWithValueText() = "exception" then result = true else result = false
  }
}
