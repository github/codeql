private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.ast.internal.Module
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
 *     User.delete_by("id = ?", uid)
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
      other.getModule() = resolveConstantReadAccess(this.getSuperclassExpr())
    )
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
class CookiesSource extends RemoteFlowSource::Range {
  CookiesCall call;

  CookiesSource() { this.asExpr().getExpr() = call }

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
      methodName = this.getKeywordArgument("action").(StringlikeLiteral).getValueText() and
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
      call.getAnArgument().(SymbolLiteral).getValueText() = "verify_authenticity_token"
    )
  }

  override boolean getVerificationSetting() { result = false }
}
