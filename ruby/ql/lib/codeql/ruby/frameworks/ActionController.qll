/**
 * Provides modeling for the `ActionController` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.ApiGraphs
private import codeql.ruby.typetracking.TypeTracking
private import codeql.ruby.frameworks.ActionDispatch
private import codeql.ruby.frameworks.ActionView
private import codeql.ruby.frameworks.Rails
private import codeql.ruby.frameworks.internal.Rails
private import codeql.ruby.dataflow.internal.DataFlowDispatch

/**
 * Provides modeling for ActionController, which is part of the `actionpack` gem.
 * Version: 7.0.
 */
module ActionController {
  // TODO: move the rest of this file inside this module.
  import codeql.ruby.frameworks.actioncontroller.Filters

  /**
   * An ActionController class which sits at the top of the class hierarchy.
   * In other words, it does not subclass any other class in source code.
   */
  class RootController extends ActionControllerClass {
    RootController() {
      not exists(ActionControllerClass parent | this != parent and this = parent.getADescendent())
    }
  }

  /**
   * A call to `protect_from_forgery`.
   */
  class ProtectFromForgeryCall extends CsrfProtectionSetting::Range, DataFlow::CallNode {
    ProtectFromForgeryCall() {
      this = actionControllerInstance().getAMethodCall("protect_from_forgery")
    }

    private string getWithValueText() {
      result = this.getKeywordArgument("with").getConstantValue().getSymbol()
    }

    // Calls without `with: :exception` can allow for bypassing CSRF protection
    // in some scenarios.
    override boolean getVerificationSetting() {
      if this.getWithValueText() = "exception" then result = true else result = false
    }
  }
}

/**
 * A class that extends `ActionController::Base`.
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
class ActionControllerClass extends DataFlow::ClassNode {
  ActionControllerClass() {
    // In Rails applications `ApplicationController` typically extends `ActionController::Base`, but we
    // treat it separately in case the `ApplicationController` definition is not in the database.
    this = DataFlow::getConstant("ApplicationController").getADescendentModule()
    or
    this = actionControllerBaseClass().getADescendentModule() and
    not exists(DataFlow::ModuleNode m | m = actionControllerBaseClass().asModule() | this = m)
  }

  /**
   * Gets an `ActionControllerActionMethod` defined in this class.
   */
  ActionControllerActionMethod getAnAction() {
    result = this.getAnInstanceMethod().asCallableAstNode()
  }

  /**
   * Gets a `self` that possibly refers to an instance of this class.
   */
  DataFlow::LocalSourceNode getSelf() {
    result = this.getAnInstanceSelf()
    or
    // Include the module-level `self` to recover some cases where a block at the module level
    // is invoked with an instance as the `self`, which we currently can't model directly.
    // Concretely this happens in the block passed to `rescue_from`.
    // TODO: revisit when we have better infrastructure for handling self in a block
    result = this.getModuleLevelSelf()
  }
}

private DataFlow::ConstRef actionControllerBaseClass() {
  result =
    [
      DataFlow::getConstant("ActionController").getConstant("Base"),
      // ActionController::Metal and ActionController::API technically don't contain all of the
      // methods available in Base, such as those for rendering views.
      // However we prefer to be over-sensitive in this case in order to find more results.
      DataFlow::getConstant("ActionController").getConstant("Metal"),
      DataFlow::getConstant("ActionController").getConstant("API")
    ]
}

private API::Node actionControllerInstance() {
  result = any(ActionControllerClass cls).getSelf().track()
}

/**
 * A public instance method defined within an `ActionController` controller class.
 * This may be the target of a route handler, if such a route is defined.
 */
class ActionControllerActionMethod extends Method, Http::Server::RequestHandler::Range {
  private ActionControllerClass controllerClass;

  ActionControllerActionMethod() {
    this = controllerClass.getAnInstanceMethod().asCallableAstNode() and not this.isPrivate()
  }

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

  override string getAnHttpMethod() { result = this.getARoute().getHttpMethod() }

  /** Gets a call to render from within this method. */
  Rails::RenderCall getARenderCall() { result.getParent+() = this }

  /**
   * Gets the controller class containing this method.
   */
  ActionControllerClass getControllerClass() {
    // TODO: model the implicit render call when a path through the method does
    // not end at an explicit render or redirect
    result = controllerClass
  }

  /**
   * Gets a route to this handler, if one exists.
   * May return multiple results.
   */
  ActionDispatch::Routing::Route getARoute() {
    exists(string name, DataFlow::MethodNode m |
      isRoute(result, name, controllerClass) and
      m = controllerClass.getInstanceMethod(name) and
      this = m.asCallableAstNode()
    )
  }
}

pragma[nomagic]
private predicate isRoute(
  ActionDispatch::Routing::Route route, string name, ActionControllerClass controllerClass
) {
  route.getController() + "_controller" =
    ActionDispatch::Routing::underscore(controllerClass.getQualifiedName()) and
  name = route.getAction()
}

/**
 * A `RemoteFlowSource::Range` to represent accessing the
 * ActionController parameters available via the `params` method.
 */
class ParamsSource extends Http::Server::RequestInputAccess::Range {
  ParamsSource() { this.asExpr().getExpr() instanceof Rails::ParamsCall }

  override string getSourceType() { result = "ActionController::Metal#params" }

  override Http::Server::RequestInputKind getKind() { result = Http::Server::parameterInputKind() }
}

/**
 * A `RemoteFlowSource::Range` to represent accessing the
 * ActionController parameters available via the `cookies` method.
 */
class CookiesSource extends Http::Server::RequestInputAccess::Range {
  CookiesSource() { this.asExpr().getExpr() instanceof Rails::CookiesCall }

  override string getSourceType() { result = "ActionController::Metal#cookies" }

  override Http::Server::RequestInputKind getKind() { result = Http::Server::cookieInputKind() }
}

/** A call to `cookies` from within a controller. */
private class ActionControllerCookiesCall extends CookiesCallImpl {
  ActionControllerCookiesCall() {
    this = actionControllerInstance().getAMethodCall("cookies").asExpr().getExpr()
  }
}

/** A call to `params` from within a controller. */
private class ActionControllerParamsCall extends ParamsCallImpl {
  ActionControllerParamsCall() {
    this = actionControllerInstance().getAMethodCall("params").asExpr().getExpr()
  }
}

/** A call to `render` from within a controller. */
private class ActionControllerRenderCall extends RenderCallImpl {
  ActionControllerRenderCall() {
    this = actionControllerInstance().getAMethodCall("render").asExpr().getExpr()
  }
}

/** A call to `render_to` from within a controller. */
private class ActionControllerRenderToCall extends RenderToCallImpl {
  ActionControllerRenderToCall() {
    this =
      actionControllerInstance()
          .getAMethodCall(["render_to_body", "render_to_string"])
          .asExpr()
          .getExpr()
  }
}

pragma[nomagic]
private DataFlow::CallNode renderCall() {
  // ActionController#render is an alias for ActionController::Renderer#render
  result =
    [
      any(ActionControllerClass c).trackModule().getAMethodCall("render"),
      any(ActionControllerClass c).trackModule().getReturn("renderer").getAMethodCall("render")
    ]
}

/** A call to `ActionController::Renderer#render`. */
private class RendererRenderCall extends RenderCallImpl {
  RendererRenderCall() { this = renderCall().asExpr().getExpr() }
}

/** A call to `html_escape` from within a controller. */
private class ActionControllerHtmlEscapeCall extends HtmlEscapeCallImpl {
  ActionControllerHtmlEscapeCall() {
    // "h" is aliased to "html_escape" in ActiveSupport
    this =
      actionControllerInstance()
          .getAMethodCall(["html_escape", "html_escape_once", "h", "sanitize"])
          .asExpr()
          .getExpr()
  }
}

/**
 * A call to the `redirect_to` method, used in an action to redirect to a
 * specific URL/path or to a different action in this controller.
 */
class RedirectToCall extends MethodCall {
  private ActionControllerClass controller;

  RedirectToCall() {
    this =
      controller
          .getSelf()
          .track()
          .getAMethodCall(["redirect_to", "redirect_back", "redirect_back_or_to"])
          .asExpr()
          .getExpr()
  }

  /** Gets the `Expr` representing the URL to redirect to, if any */
  Expr getRedirectUrl() {
    this.getMethodName() = "redirect_back" and result = this.getKeywordArgument("fallback_location")
    or
    this.getMethodName() = ["redirect_to", "redirect_back_or_to"] and result = this.getArgument(0)
  }

  /** Gets the `ActionControllerActionMethod` to redirect to, if any */
  ActionControllerActionMethod getRedirectActionMethod() {
    exists(string name |
      this.getKeywordArgument("action").getConstantValue().isStringlikeValue(name) and
      result = controller.getInstanceMethod(name).asCallableAstNode()
    )
  }

  /**
   * Holds if this method call allows a redirect to an external host.
   */
  predicate allowsExternalRedirect() {
    // Unless the option allow_other_host is explicitly set to false, assume that external redirects are allowed.
    // TODO: Take into account `config.action_controller.raise_on_open_redirects`.
    // TODO: Take into account that this option defaults to false in Rails 7.
    not this.getKeywordArgument("allow_other_host").getConstantValue().isBoolean(false)
  }
}

/**
 * A call to the `redirect_to` method, as an `HttpRedirectResponse`.
 */
class ActionControllerRedirectResponse extends Http::Server::HttpRedirectResponse::Range {
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
private predicate actionControllerHasHelperMethodCall(ActionControllerClass c, string name) {
  c.getAModuleLevelCall("helper_method").getArgument(_).getConstantValue().isStringlikeValue(name)
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
  private ActionControllerClass controllerClass;

  ActionControllerHelperMethod() {
    exists(DataFlow::MethodNode m, string name |
      m = controllerClass.getInstanceMethod(name) and
      actionControllerHasHelperMethodCall(controllerClass, name) and
      this = m.asCallableAstNode()
    )
  }

  /** Gets the class containing this helper method. */
  ActionControllerClass getControllerClass() { result = controllerClass }
}

/**
 * Gets an `ActionControllerClass` associated with the given `ErbFile`
 * according to Rails path conventions.
 * For instance, a template file at `app/views/foo/bar/baz.html.erb` will be
 * mapped to a controller class in `app/controllers/foo/bar/baz_controller.rb`,
 * if such a controller class exists.
 */
ActionControllerClass getAssociatedControllerClass(ErbFile f) {
  // There is a direct mapping from template file to controller class
  controllerTemplateFile(result, f)
  or
  // The template `f` is a partial, and it is rendered from within another
  // template file, `fp`. In this case, `f` inherits the associated
  // controller classes from `fp`.
  f.isPartial() and
  exists(Rails::RenderCall r, ErbFile fp |
    r.getLocation().getFile() = fp and
    r.getTemplateFile() = f and
    result = getAssociatedControllerClass(fp)
  )
}

pragma[nomagic]
private string getActionControllerClassRelativePath(ActionControllerClass cls) {
  result = cls.getLocation().getFile().getRelativePath()
}

pragma[nomagic]
private string getErbFileRelativePath(ErbFile templateFile) {
  result = templateFile.getRelativePath() and
  result.matches("%app/views/layouts/%")
}

bindingset[result]
pragma[inline_late]
private string getErbFileRelativePathInlineLate(ErbFile templateFile) {
  result = getErbFileRelativePath(templateFile)
}

// TODO: improve layout support, e.g. for `layout` method
// https://guides.rubyonrails.org/layouts_and_rendering.html
/**
 * Holds if `templateFile` is a viable file "belonging" to the given
 * `ActionControllerControllerClass`, according to Rails conventions.
 *
 * This handles mappings between controllers in `app/controllers/`, and
 * templates in `app/views/` and `app/views/layouts/`.
 */
predicate controllerTemplateFile(ActionControllerClass cls, ErbFile templateFile) {
  exists(string sourcePrefix, string subPath, string controllerPath |
    controllerPath = getActionControllerClassRelativePath(cls) and
    // `sourcePrefix` is either a prefix path ending in a slash, or empty if
    // the rails app is at the source root
    sourcePrefix =
      [controllerPath.regexpCapture("^(.*/)app/controllers/(?:[^/]+/)?(?:[^/]*)$", 1), ""] and
    controllerPath = sourcePrefix + "app/controllers/" + subPath + "_controller.rb"
  |
    sourcePrefix + "app/views/" + subPath = templateFile.getParentContainer().getRelativePath()
    or
    exists(string path |
      path = getErbFileRelativePath(_) and
      path.matches(sourcePrefix + "app/views/layouts/" + subPath + "%") and
      path = getErbFileRelativePathInlineLate(templateFile)
    )
  )
}

/**
 * A call to either `skip_forgery_protection` or
 * `skip_before_action :verify_authenticity_token` to disable CSRF authenticity
 * token protection.
 */
class ActionControllerSkipForgeryProtectionCall extends CsrfProtectionSetting::Range {
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
 * A call to `send_file`, which sends the file at the given path to the client.
 */
private class SendFile extends FileSystemAccess::Range, Http::Server::HttpResponse::Range,
  DataFlow::CallNode
{
  SendFile() {
    this = [actionControllerInstance(), Response::response()].getAMethodCall("send_file")
  }

  override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }

  override DataFlow::Node getBody() { result = this.getArgument(0) }

  override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

  override string getMimetypeDefault() { result = "application/octet-stream" }
}

/**
 * A call to `send_data`, which sends the given data to the client.
 */
class SendDataCall extends DataFlow::CallNode, Http::Server::HttpResponse::Range {
  SendDataCall() {
    this = [actionControllerInstance(), Response::response()].getAMethodCall("send_data")
  }

  override DataFlow::Node getBody() { result = this.getArgument(0) }

  override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

  override string getMimetypeDefault() { result = "application/octet-stream" }
}

private module ParamsSummaries {
  private import codeql.ruby.dataflow.FlowSummary

  /**
   * Gets an instance of `ActionController::Parameters`, including those returned
   * from method calls on other instances.
   */
  private DataFlow::LocalSourceNode paramsInstance() {
    result.asExpr().getExpr() instanceof Rails::ParamsCall
    or
    result = paramsInstance().getAMethodCall(paramsMethodReturningParamsInstance())
  }

  /**
   * Methods on `ActionController::Parameters` that return an instance of
   * `ActionController::Parameters`.
   */
  string paramsMethodReturningParamsInstance() {
    result =
      [
        "concat", "concat!", "compact_blank", "deep_dup", "deep_transform_keys", "delete_if",
        // dig doesn't always return a Parameters instance, but it will if the
        // given key refers to a nested hash parameter.
        "dig", "each", "each_key", "each_pair", "each_value", "except", "keep_if", "merge",
        "merge!", "permit", "reject", "reject!", "require", "reverse_merge", "reverse_merge!",
        "select", "select!", "slice", "slice!", "transform_keys", "transform_keys!",
        "transform_values", "transform_values!", "with_defaults", "with_defaults!", "[]"
      ]
  }

  /**
   * Methods on `ActionController::Parameters` that propagate taint from
   * receiver to return value.
   */
  string methodReturnsTaintFromSelf() {
    result =
      [
        "as_json", "permit", "require", "required", "deep_dup", "deep_transform_keys",
        "deep_transform_keys!", "delete_if", "extract!", "keep_if", "select", "select!", "reject",
        "reject!", "to_h", "to_hash", "to_query", "to_param", "to_unsafe_h", "to_unsafe_hash",
        "transform_keys", "transform_keys!", "transform_values", "transform_values!", "values_at"
      ]
  }

  /** Gets a node that may be tainted from an `ActionController::Parameters` instance, through field accesses and hash/array element reads. */
  private DataFlow::LocalSourceNode taintFromParamsBase() {
    result =
      [
        paramsInstance(),
        paramsInstance().getAMethodCall(methodReturnsTaintFromSelf()).getAnElementRead*()
      ]
  }

  private DataFlow::LocalSourceNode taintFromParamsType(TypeTracker t) {
    t.start() and
    result = taintFromParamsBase()
    or
    exists(TypeTracker t2 | result = taintFromParamsType(t2).track(t2, t))
  }

  /** Gets a node with a type that may be tainted from an `ActionController::Parameters` instance. */
  private DataFlow::LocalSourceNode taintFromParamsType() {
    taintFromParamsType(TypeTracker::end()).flowsTo(result)
  }

  /**
   * A flow summary for methods on `ActionController::Parameters` which
   * propagate taint from receiver to return value.
   */
  private class MethodsReturningParamsInstanceSummary extends SummarizedCallable {
    MethodsReturningParamsInstanceSummary() { this = "ActionController::Parameters#<various>" }

    override MethodCall getACall() {
      result = paramsInstance().getAMethodCall(methodReturnsTaintFromSelf()).asExpr().getExpr()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /**
   * `#merge`
   * Returns a new ActionController::Parameters with all keys from other_hash merged into current hash.
   * `#reverse_merge`
   * `#with_defaults`
   * Returns a new ActionController::Parameters with all keys from current hash merged into other_hash.
   */
  private class MergeSummary extends SummarizedCallable {
    MergeSummary() { this = "ActionController::Parameters#merge" }

    override MethodCall getACall() {
      result.getMethodName() = ["merge", "reverse_merge", "with_defaults"] and
      paramsInstance().getALocalUse().asExpr().getExpr() =
        [result.getReceiver(), result.getArgument(0)]
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = ["Argument[self]", "Argument[0]"] and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /**
   * `#merge!`
   * Returns current ActionController::Parameters instance with current hash merged into other_hash.
   * `#reverse_merge!`
   * `#with_defaults!`
   * `#reverse_update`
   * Returns a new ActionController::Parameters with all keys from current hash merged into other_hash.
   */
  private class MergeBangSummary extends SummarizedCallable {
    MergeBangSummary() { this = "ActionController::Parameters#merge!" }

    override MethodCall getACall() {
      result.getMethodName() = ["merge!", "reverse_merge!", "with_defaults!", "reverse_update"] and
      paramsInstance().getALocalUse().asExpr().getExpr() =
        [result.getReceiver(), result.getArgument(0)]
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = ["Argument[self]", "Argument[0]"] and
      output = ["ReturnValue", "Argument[self]"] and
      preservesValue = false
    }
  }

  /** Flow summaries for `ActiveDispatch::Http::UploadedFile`, which can be an field of `ActionController::Parameters`. */
  module UploadedFileSummaries {
    /** Flow summary for various string attributes of `UploadedFile`, including `original_filename`, `content_type`, and `headers`. */
    private class UploadedFileStringAttributeSummary extends SummarizedCallable {
      UploadedFileStringAttributeSummary() {
        this = "ActionDispatch::Http::UploadedFile#[original_filename,content_type,headers]"
      }

      override MethodCall getACall() {
        result =
          taintFromParamsType()
              .getAMethodCall(["original_filename", "content_type", "headers"])
              .asExpr()
              .getExpr() and
        result.getNumberOfArguments() = 0
      }

      override predicate propagatesFlow(string input, string output, boolean preservesValue) {
        input = "Argument[self]" and output = "ReturnValue" and preservesValue = false
      }
    }

    /**
     * Flow summary for `ActiveDispatch::Http::UploadedFile#read`,
     * which propagates taint from the receiver to the return value or to the second (out string) argument
     */
    private class UploadedFileReadSummary extends SummarizedCallable {
      UploadedFileReadSummary() { this = "ActionDispatch::Http::UploadedFile#read" }

      override MethodCall getACall() {
        result = taintFromParamsType().getAMethodCall("read").asExpr().getExpr() and
        result.getNumberOfArguments() in [0 .. 2]
      }

      override predicate propagatesFlow(string input, string output, boolean preservesValue) {
        input = "Argument[self]" and
        output = ["ReturnValue", "Argument[1]"] and
        preservesValue = false
      }
    }
  }
}

/**
 * Provides modeling for `ActionDispatch::Response`, which represents an HTTP
 * response.
 */
private module Response {
  API::Node response() { result = actionControllerInstance().getReturn("response") }

  class BodyWrite extends DataFlow::CallNode, Http::Server::HttpResponse::Range {
    BodyWrite() { this = response().getAMethodCall("body=") }

    override DataFlow::Node getBody() { result = this.getArgument(0) }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    override string getMimetypeDefault() { result = "text/http" }
  }

  class SendFileCall extends DataFlow::CallNode, Http::Server::HttpResponse::Range {
    SendFileCall() { this = response().getAMethodCall("send_file") }

    override DataFlow::Node getBody() { result = this.getArgument(0) }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    override string getMimetypeDefault() { result = "application/octet-stream" }
  }

  class HeaderWrite extends DataFlow::CallNode, Http::Server::HeaderWriteAccess::Range {
    HeaderWrite() {
      // response.header[key] = val
      // response.headers[key] = val
      this = response().getReturn(["header", "headers"]).getAMethodCall("[]=")
      or
      // response.set_header(key) = val
      // response[header] = val
      // response.add_header(key, val)
      this = response().getAMethodCall(["set_header", "[]=", "add_header"])
    }

    override string getName() {
      result = this.getArgument(0).asExpr().getConstantValue().getString()
    }

    override DataFlow::Node getValue() { result = this.getArgument(1) }
  }

  class SpecificHeaderWrite extends DataFlow::CallNode, Http::Server::HeaderWriteAccess::Range {
    SpecificHeaderWrite() {
      // response.<method> = val
      this =
        response()
            .getAMethodCall([
                "location=", "cache_control=", "_cache_control=", "etag=", "charset=",
                "content_type=", "date=", "last_modified=", "weak_etag=", "strong_etag="
              ])
    }

    override string getName() {
      this.getMethodName() = "location=" and result = "location"
      or
      this.getMethodName() = ["_cache_control=", "cache_control="] and result = "cache-control"
      or
      this.getMethodName() = ["etag=", "weak_etag=", "strong_etag="] and result = "etag"
      or
      // sets the charset part of the content-type header
      this.getMethodName() = ["charset=", "content_type="] and result = "content-type"
      or
      this.getMethodName() = "date=" and result = "date"
      or
      this.getMethodName() = "last_modified=" and result = "last-modified"
    }

    override DataFlow::Node getValue() { result = this.getArgument(0) }
  }
}

private class ActionControllerLoggingCall extends DataFlow::CallNode, Logging::Range {
  ActionControllerLoggingCall() {
    this =
      actionControllerInstance()
          .getReturn("logger")
          .getAMethodCall(["debug", "error", "fatal", "info", "unknown", "warn"])
  }

  // Note: this is identical to the definition `stdlib.Logger.LoggerInfoStyleCall`.
  override DataFlow::Node getAnInput() {
    // `msg` from `Logger#info(msg)`,
    // or `progname` from `Logger#info(progname) <block>`
    result = this.getArgument(0)
    or
    // a return value from the block in `Logger#info(progname) <block>`
    exprNodeReturnedFrom(result, this.getBlock().asExpr().getExpr())
  }
}
