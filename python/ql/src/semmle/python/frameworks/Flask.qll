/**
 * Provides classes modeling security-relevant aspects of the `flask` PyPI package.
 * See https://flask.palletsprojects.com/en/1.1.x/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.frameworks.Werkzeug
private import semmle.python.ApiGraphs

/**
 * Provides models for the `flask` PyPI package.
 * See https://flask.palletsprojects.com/en/1.1.x/.
 */
module Flask {
  /** Provides models for flask view classes (defined in the `flask.views` module) */
  module Views {
    /**
     * Provides models for the `flask.views.View` class and subclasses.
     *
     * See https://flask.palletsprojects.com/en/1.1.x/views/#basic-principle.
     */
    module View {
      /** Gets a reference to the `flask.views.View` class or any subclass. */
      API::Node subclassRef() {
        result =
          API::moduleImport("flask")
              .getMember("views")
              .getMember([
                  "View",
                  // MethodView is a known subclass
                  "MethodView"
                ])
              .getASubclass*()
      }
    }

    /**
     * Provides models for the `flask.views.MethodView` class and subclasses.
     *
     * See https://flask.palletsprojects.com/en/1.1.x/views/#method-based-dispatching.
     */
    module MethodView {
      /** Gets a reference to the `flask.views.MethodView` class or any subclass. */
      API::Node subclassRef() {
        result =
          API::moduleImport("flask").getMember("views").getMember("MethodView").getASubclass*()
      }
    }
  }

  /**
   * Provides models for flask applications (instances of the `flask.Flask` class).
   *
   * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.
   */
  module FlaskApp {
    /** Gets a reference to the `flask.Flask` class. */
    API::Node classRef() { result = API::moduleImport("flask").getMember("Flask") }

    /** Gets a reference to an instance of `flask.Flask` (a flask application). */
    API::Node instance() { result = classRef().getReturn() }
  }

  /**
   * Provides models for flask blueprints (instances of the `flask.Blueprint` class).
   *
   * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Blueprint.
   */
  module Blueprint {
    /** Gets a reference to the `flask.Blueprint` class. */
    API::Node classRef() { result = API::moduleImport("flask").getMember("Blueprint") }

    /** Gets a reference to an instance of `flask.Blueprint`. */
    API::Node instance() { result = classRef().getReturn() }
  }

  /** Gets a reference to the `flask.request` object. */
  API::Node request() { result = API::moduleImport("flask").getMember("request") }

  /**
   * Provides models for the `flask.Response` class
   *
   * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Response.
   */
  module Response {
    /**
     * Gets a reference to the `flask.Response` class, possibly through the
     * `response_class` class attribute on a flask application (which by is an alias for
     * `flask.Response` by default).
     */
    API::Node classRef() {
      result = API::moduleImport("flask").getMember("Response")
      or
      result = [FlaskApp::classRef(), FlaskApp::instance()].getMember("response_class")
    }

    /**
     * INTERNAL: Do not use.
     *
     * A source of instances of `flask.Response`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Response::instance()` to get references to instances of `flask.Response`.
     */
    abstract class InstanceSource extends HTTP::Server::HttpResponse::Range, DataFlow::Node { }

    /** A direct instantiation of `flask.Response`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = classRef().getACall() }

      override DataFlow::Node getBody() { result = this.getArg(0) }

      override string getMimetypeDefault() { result = "text/html" }

      /** Gets the argument passed to the `mimetype` parameter, if any. */
      private DataFlow::Node getMimetypeArg() {
        result in [this.getArg(3), this.getArgByName("mimetype")]
      }

      /** Gets the argument passed to the `content_type` parameter, if any. */
      private DataFlow::Node getContentTypeArg() {
        result in [this.getArg(4), this.getArgByName("content_type")]
      }

      override DataFlow::Node getMimetypeOrContentTypeArg() {
        result = this.getContentTypeArg()
        or
        // content_type argument takes priority over mimetype argument
        not exists(this.getContentTypeArg()) and
        result = this.getMimetypeArg()
      }
    }

    /**
     * A call to either `flask.make_response` function, or the `make_response` method on
     * an instance of `flask.Flask`. This creates an instance of the `flask_response`
     * class (class-attribute on a flask application), which by default is
     * `flask.Response`.
     *
     * See
     * - https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.make_response
     * - https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response
     */
    private class FlaskMakeResponseCall extends InstanceSource, DataFlow::CallCfgNode {
      FlaskMakeResponseCall() {
        this = API::moduleImport("flask").getMember("make_response").getACall()
        or
        this = FlaskApp::instance().getMember("make_response").getACall()
      }

      override DataFlow::Node getBody() { result = this.getArg(0) }

      override string getMimetypeDefault() { result = "text/html" }

      override DataFlow::Node getMimetypeOrContentTypeArg() { none() }
    }

    /** Gets a reference to an instance of `flask.Response`. */
    private DataFlow::LocalSourceNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `flask.Response`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
  }

  // ---------------------------------------------------------------------------
  // routing modeling
  // ---------------------------------------------------------------------------
  /**
   * A class that is a subclass of the `flask.views.View` class,
   * thereby being able to handle incoming HTTP requests.
   */
  class FlaskViewClass extends Class {
    API::Node api_node;

    FlaskViewClass() {
      this.getABase() = Views::View::subclassRef().getAUse().asExpr() and
      api_node.getAnImmediateUse().asExpr().(ClassExpr) = this.getParent()
    }

    /** Gets a function that could handle incoming requests, if any. */
    Function getARequestHandler() {
      // TODO: This doesn't handle attribute assignment. Should be OK, but analysis is not as complete as with
      // points-to and `.lookup`, which would handle `post = my_post_handler` inside class def
      result = this.getAMethod() and
      result.getName() = "dispatch_request"
    }

    /**
     * INTERNAL: Do not use.
     * Gets a reference to the result of calling the `as_view` classmethod of this class.
     */
    API::Node asViewResult() { result = api_node.getMember("as_view").getReturn() }
  }

  /**
   * A class that is a subclass of the `flask.views.MethodView` class.
   * thereby being able to handle incoming HTTP requests.
   */
  class FlaskMethodViewClass extends FlaskViewClass {
    FlaskMethodViewClass() {
      this.getABase() = Views::MethodView::subclassRef().getAUse().asExpr() and
      api_node.getAnImmediateUse().asExpr().(ClassExpr) = this.getParent()
    }

    override Function getARequestHandler() {
      result = super.getARequestHandler()
      or
      // TODO: This doesn't handle attribute assignment. Should be OK, but analysis is not as complete as with
      // points-to and `.lookup`, which would handle `post = my_post_handler` inside class def
      result = this.getAMethod() and
      result.getName() = HTTP::httpVerbLower()
    }
  }

  private string werkzeug_rule_re() {
    // since flask uses werkzeug internally, we are using its routing rules from
    // https://github.com/pallets/werkzeug/blob/4dc8d6ab840d4b78cbd5789cef91b01e3bde01d5/src/werkzeug/routing.py#L138-L151
    result =
      "(?<static>[^<]*)<(?:(?<converter>[a-zA-Z_][a-zA-Z0-9_]*)(?:\\((?<args>.*?)\\))?\\:)?(?<variable>[a-zA-Z_][a-zA-Z0-9_]*)>"
  }

  /** A route setup made by flask (sharing handling of URL patterns). */
  abstract private class FlaskRouteSetup extends HTTP::Server::RouteSetup::Range {
    override Parameter getARoutedParameter() {
      // If we don't know the URL pattern, we simply mark all parameters as a routed
      // parameter. This should give us more RemoteFlowSources but could also lead to
      // more FPs. If this turns out to be the wrong tradeoff, we can always change our mind.
      not exists(this.getUrlPattern()) and
      result = this.getARequestHandler().getArgByName(_)
      or
      exists(string name |
        result = this.getARequestHandler().getArgByName(name) and
        exists(string match |
          match = this.getUrlPattern().regexpFind(werkzeug_rule_re(), _, _) and
          name = match.regexpCapture(werkzeug_rule_re(), 4)
        )
      )
    }

    override string getFramework() { result = "Flask" }
  }

  /**
   * A call to the `route` method on an instance of `flask.Flask` or an instance of `flask.Blueprint`.
   *
   * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.route
   */
  private class FlaskAppRouteCall extends FlaskRouteSetup, DataFlow::CallCfgNode {
    FlaskAppRouteCall() {
      this = FlaskApp::instance().getMember("route").getACall()
      or
      this = Blueprint::instance().getMember("route").getACall()
    }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(0), this.getArgByName("rule")]
    }

    override Function getARequestHandler() { result.getADecorator().getAFlowNode() = node }
  }

  /**
   * A call to the `add_url_rule` method on an instance of `flask.Flask` or an instance of `flask.Blueprint`.
   *
   * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.add_url_rule
   */
  private class FlaskAppAddUrlRuleCall extends FlaskRouteSetup, DataFlow::CallCfgNode {
    FlaskAppAddUrlRuleCall() {
      this = FlaskApp::instance().getMember("add_url_rule").getACall()
      or
      this = Blueprint::instance().getMember("add_url_rule").getACall()
    }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(0), this.getArgByName("rule")]
    }

    DataFlow::Node getViewArg() { result in [this.getArg(2), this.getArgByName("view_func")] }

    override Function getARequestHandler() {
      exists(DataFlow::LocalSourceNode func_src |
        func_src.flowsTo(getViewArg()) and
        func_src.asExpr().(CallableExpr) = result.getDefinition()
      )
      or
      exists(FlaskViewClass vc |
        getViewArg() = vc.asViewResult().getAUse() and
        result = vc.getARequestHandler()
      )
    }
  }

  /** A request handler defined in a django view class, that has no known route. */
  private class FlaskViewClassHandlerWithoutKnownRoute extends HTTP::Server::RequestHandler::Range {
    FlaskViewClassHandlerWithoutKnownRoute() {
      exists(FlaskViewClass vc | vc.getARequestHandler() = this) and
      not exists(FlaskRouteSetup setup | setup.getARequestHandler() = this)
    }

    override Parameter getARoutedParameter() {
      // Since we don't know the URL pattern, we simply mark all parameters as a routed
      // parameter. This should give us more RemoteFlowSources but could also lead to
      // more FPs. If this turns out to be the wrong tradeoff, we can always change our mind.
      result in [this.getArg(_), this.getArgByName(_)] and
      not result = this.getArg(0)
    }

    override string getFramework() { result = "Flask" }
  }

  // ---------------------------------------------------------------------------
  // flask.Request taint modeling
  // ---------------------------------------------------------------------------
  /**
   * A source of remote flow from a flask request.
   *
   * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Request
   */
  private class FlaskRequestSource extends RemoteFlowSource::Range {
    FlaskRequestSource() {
      this = request().getAUse() and
      not any(Import imp).contains(this.asExpr()) and
      not exists(ControlFlowNode def | this.asVar().getSourceVariable().hasDefiningNode(def) |
        any(Import imp).contains(def.getNode())
      )
    }

    override string getSourceType() { result = "flask.request" }
  }

  /**
   * Taint propagation for a flask request.
   *
   * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Request
   */
  private class FlaskRequestAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      // Methods
      exists(string method_name | method_name in ["get_data", "get_json"] |
        // Method access
        nodeFrom = request().getAUse() and
        nodeTo.(DataFlow::AttrRead).getObject() = nodeFrom and
        nodeTo.(DataFlow::AttrRead).getAttributeName() = method_name
        or
        // Method call
        nodeFrom = request().getMember(method_name).getAUse() and
        nodeTo.(DataFlow::CallCfgNode).getFunction() = nodeFrom
      )
      or
      // Attributes
      nodeFrom = request().getAUse() and
      exists(DataFlow::AttrRead read | nodeTo = read and read.getObject() = nodeFrom |
        read.getAttributeName() in [
            // str
            "path", "full_path", "base_url", "url", "access_control_request_method",
            "content_encoding", "content_md5", "content_type", "data", "method", "mimetype",
            "origin", "query_string", "referrer", "remote_addr", "remote_user", "user_agent",
            // dict
            "environ", "cookies", "mimetype_params", "view_args",
            // json
            "json",
            // List[str]
            "access_route",
            // file-like
            "stream", "input_stream",
            // MultiDict[str, str]
            // https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.MultiDict
            "args", "values", "form",
            // MultiDict[str, FileStorage]
            // https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.FileStorage
            // TODO: FileStorage needs extra taint steps
            "files",
            // https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.HeaderSet
            "access_control_request_headers", "pragma",
            // https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.Accept
            // TODO: Kinda badly modeled for now -- has type List[Tuple[value, quality]], and some extra methods
            "accept_charsets", "accept_encodings", "accept_languages", "accept_mimetypes",
            // https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.Authorization
            // TODO: dict subclass with extra attributes like `username` and `password`
            "authorization",
            // https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.RequestCacheControl
            // TODO: has attributes like `no_cache`, and `to_header` method (actually, many of these models do)
            "cache_control",
            // https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.Headers
            // TODO: dict-like with wsgiref.headers.Header compatibility methods
            "headers"
          ]
      )
    }
  }

  private class RequestAttrMultiDict extends Werkzeug::werkzeug::datastructures::MultiDict::InstanceSource {
    string attr_name;

    RequestAttrMultiDict() {
      attr_name in ["args", "values", "form", "files"] and
      this = request().getMember(attr_name).getAnImmediateUse()
    }
  }

  private class RequestAttrFiles extends RequestAttrMultiDict {
    // TODO: Somehow specify that elements of `RequestAttrFiles` are
    // Werkzeug::werkzeug::datastructures::FileStorage and should have those additional taint steps
    // AND that the 0-indexed argument to its' save method is a sink for path-injection.
    // https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.FileStorage.save
    RequestAttrFiles() { attr_name = "files" }
  }

  // ---------------------------------------------------------------------------
  // Implicit response from returns of flask request handlers
  // ---------------------------------------------------------------------------
  private class FlaskRouteHandlerReturn extends HTTP::Server::HttpResponse::Range, DataFlow::CfgNode {
    FlaskRouteHandlerReturn() {
      exists(Function routeHandler |
        routeHandler = any(FlaskRouteSetup rs).getARequestHandler() and
        node = routeHandler.getAReturnValueFlowNode()
      )
    }

    override DataFlow::Node getBody() { result = this }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    override string getMimetypeDefault() { result = "text/html" }
  }

  // ---------------------------------------------------------------------------
  // flask.redirect
  // ---------------------------------------------------------------------------
  /**
   * A call to the `flask.redirect` function.
   *
   * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.redirect
   */
  private class FlaskRedirectCall extends HTTP::Server::HttpRedirectResponse::Range,
    DataFlow::CallCfgNode {
    FlaskRedirectCall() { this = API::moduleImport("flask").getMember("redirect").getACall() }

    override DataFlow::Node getRedirectLocation() {
      result in [this.getArg(0), this.getArgByName("location")]
    }

    override DataFlow::Node getBody() { none() }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    override string getMimetypeDefault() {
      // note that while you're not able to set content yourself, the function will
      // actually fill out some default content, that is served with mimetype
      // `text/html`.
      result = "text/html"
    }
  }
}
