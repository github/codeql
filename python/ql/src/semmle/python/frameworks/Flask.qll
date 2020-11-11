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

/**
 * Provides models for the `flask` PyPI package.
 * See https://flask.palletsprojects.com/en/1.1.x/.
 */
private module FlaskModel {
  // ---------------------------------------------------------------------------
  // flask
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `flask` module. */
  private DataFlow::Node flask(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("flask")
    or
    exists(DataFlow::TypeTracker t2 | result = flask(t2).track(t2, t))
  }

  /** Gets a reference to the `flask` module. */
  DataFlow::Node flask() { result = flask(DataFlow::TypeTracker::end()) }

  /**
   * Gets a reference to the attribute `attr_name` of the `flask` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node flask_attr(DataFlow::TypeTracker t, string attr_name) {
    attr_name in ["request", "make_response", "Response"] and
    (
      t.start() and
      result = DataFlow::importNode("flask" + "." + attr_name)
      or
      t.startInAttr(attr_name) and
      result = flask()
    )
    or
    // Due to bad performance when using normal setup with `flask_attr(t2, attr_name).track(t2, t)`
    // we have inlined that code and forced a join
    exists(DataFlow::TypeTracker t2 |
      exists(DataFlow::StepSummary summary |
        flask_attr_first_join(t2, attr_name, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  pragma[nomagic]
  private predicate flask_attr_first_join(
    DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
  ) {
    DataFlow::StepSummary::step(flask_attr(t2, attr_name), res, summary)
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `flask` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node flask_attr(string attr_name) {
    result = flask_attr(DataFlow::TypeTracker::end(), attr_name)
  }

  /** Provides models for the `flask` module. */
  module flask {
    /** Gets a reference to the `flask.request` object. */
    DataFlow::Node request() { result = flask_attr("request") }

    /** Gets a reference to the `flask.make_response` function. */
    DataFlow::Node make_response() { result = flask_attr("make_response") }

    /**
     * Provides models for the `flask.Flask` class
     *
     * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.
     */
    module Flask {
      /** Gets a reference to the `flask.Flask` class. */
      private DataFlow::Node classRef(DataFlow::TypeTracker t) {
        t.start() and
        result = DataFlow::importNode("flask.Flask")
        or
        t.startInAttr("Flask") and
        result = flask()
        or
        exists(DataFlow::TypeTracker t2 | result = classRef(t2).track(t2, t))
      }

      /** Gets a reference to the `flask.Flask` class. */
      DataFlow::Node classRef() { result = classRef(DataFlow::TypeTracker::end()) }

      /**
       * A source of an instance of `flask.Flask`.
       *
       * This can include instantiation of the class, return value from function
       * calls, or a special parameter that will be set when functions are call by external
       * library.
       *
       * Use `Flask::instance()` predicate to get references to instances of `flask.Flask`.
       */
      abstract class InstanceSource extends DataFlow::Node { }

      /** A direct instantiation of `flask.Flask`. */
      private class ClassInstantiation extends InstanceSource, DataFlow::CfgNode {
        override CallNode node;

        ClassInstantiation() { node.getFunction() = classRef().asCfgNode() }
      }

      /** Gets a reference to an instance of `flask.Flask` (a flask application). */
      private DataFlow::Node instance(DataFlow::TypeTracker t) {
        t.start() and
        result instanceof InstanceSource
        or
        exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
      }

      /** Gets a reference to an instance of `flask.Flask` (a flask application). */
      DataFlow::Node instance() { result = instance(DataFlow::TypeTracker::end()) }

      /**
       * Gets a reference to the attribute `attr_name` of an instance of `flask.Flask` (a flask application).
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node instance_attr(DataFlow::TypeTracker t, string attr_name) {
        attr_name in ["route", "add_url_rule", "make_response"] and
        t.startInAttr(attr_name) and
        result = flask::Flask::instance()
        or
        // Due to bad performance when using normal setup with `instance_attr(t2, attr_name).track(t2, t)`
        // we have inlined that code and forced a join
        exists(DataFlow::TypeTracker t2 |
          exists(DataFlow::StepSummary summary |
            instance_attr_first_join(t2, attr_name, result, summary) and
            t = t2.append(summary)
          )
        )
      }

      pragma[nomagic]
      private predicate instance_attr_first_join(
        DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
        DataFlow::StepSummary summary
      ) {
        DataFlow::StepSummary::step(instance_attr(t2, attr_name), res, summary)
      }

      /**
       * Gets a reference to the attribute `attr_name` of an instance of `flask.Flask` (a flask application).
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node instance_attr(string attr_name) {
        result = instance_attr(DataFlow::TypeTracker::end(), attr_name)
      }

      /** Gets a reference to the `route` method on an instance of `flask.Flask`. */
      DataFlow::Node route() { result = instance_attr("route") }

      /** Gets a reference to the `add_url_rule` method on an instance of `flask.Flask`. */
      DataFlow::Node add_url_rule() { result = instance_attr("add_url_rule") }

      /** Gets a reference to the `make_response` method on an instance of `flask.Flask`. */
      // HACK: We can't call this predicate `make_response` since shadowing is
      // completely disallowed in QL. I added an underscore to move things forward for
      // now :(
      DataFlow::Node make_response_() { result = instance_attr("make_response") }

      /** Gets a reference to the `response_class` attribute on the `flask.Flask` class or an instance. */
      private DataFlow::Node response_class(DataFlow::TypeTracker t) {
        t.startInAttr("response_class") and
        result in [classRef(), instance()]
        or
        exists(DataFlow::TypeTracker t2 | result = response_class(t2).track(t2, t))
      }

      /**
       * Gets a reference to the `response_class` attribute on the `flask.Flask` class or an instance.
       *
       * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.response_class
       */
      DataFlow::Node response_class() { result = response_class(DataFlow::TypeTracker::end()) }
    }
  }

  /**
   * Provides models for the `flask.Response` class
   *
   * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Response.
   */
  module Response {
    /** Gets a reference to the `flask.Response` class. */
    private DataFlow::Node classRef(DataFlow::TypeTracker t) {
      t.start() and
      result in [flask_attr("Response"), flask::Flask::response_class()]
      or
      exists(DataFlow::TypeTracker t2 | result = classRef(t2).track(t2, t))
    }

    /** Gets a reference to the `flask.Response` class. */
    DataFlow::Node classRef() { result = classRef(DataFlow::TypeTracker::end()) }

    /**
     * A source of an instance of `flask.Response`.
     *
     * This can include instantiation of the class, return value from function
     * calls, or a special parameter that will be set when functions are call by external
     * library.
     *
     * Use `Response::instance()` predicate to get references to instances of `flask.Response`.
     */
    abstract class InstanceSource extends HTTP::Server::HttpResponse::Range, DataFlow::Node { }

    /** A direct instantiation of `flask.Response`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CfgNode {
      override CallNode node;

      ClassInstantiation() { node.getFunction() = classRef().asCfgNode() }

      override DataFlow::Node getBody() { result.asCfgNode() = node.getArg(0) }

      override string getMimetypeDefault() { result = "text/html" }

      /** Gets the argument passed to the `mimetype` parameter, if any. */
      private DataFlow::Node getMimetypeArg() {
        result.asCfgNode() in [node.getArg(3), node.getArgByName("mimetype")]
      }

      /** Gets the argument passed to the `content_type` parameter, if any. */
      private DataFlow::Node getContentTypeArg() {
        result.asCfgNode() in [node.getArg(4), node.getArgByName("content_type")]
      }

      override DataFlow::Node getMimetypeOrContentTypeArg() {
        result = this.getContentTypeArg()
        or
        // content_type argument takes priority over mimetype argument
        not exists(this.getContentTypeArg()) and
        result = this.getMimetypeArg()
      }
    }

    /** Gets a reference to an instance of `flask.Response`. */
    private DataFlow::Node instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `flask.Response`. */
    DataFlow::Node instance() { result = instance(DataFlow::TypeTracker::end()) }
  }

  // ---------------------------------------------------------------------------
  // routing modeling
  // ---------------------------------------------------------------------------
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
      result = this.getARouteHandler().getArgByName(_)
      or
      exists(string name |
        result = this.getARouteHandler().getArgByName(name) and
        exists(string match |
          match = this.getUrlPattern().regexpFind(werkzeug_rule_re(), _, _) and
          name = match.regexpCapture(werkzeug_rule_re(), 4)
        )
      )
    }
  }

  /**
   * A call to the `route` method on an instance of `flask.Flask`.
   *
   * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.route
   */
  private class FlaskAppRouteCall extends FlaskRouteSetup, DataFlow::CfgNode {
    override CallNode node;

    FlaskAppRouteCall() { node.getFunction() = flask::Flask::route().asCfgNode() }

    override DataFlow::Node getUrlPatternArg() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("rule")]
    }

    override Function getARouteHandler() { result.getADecorator().getAFlowNode() = node }
  }

  /**
   * A call to the `add_url_rule` method on an instance of `flask.Flask`.
   *
   * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.add_url_rule
   */
  private class FlaskAppAddUrlRuleCall extends FlaskRouteSetup, DataFlow::CfgNode {
    override CallNode node;

    FlaskAppAddUrlRuleCall() { node.getFunction() = flask::Flask::add_url_rule().asCfgNode() }

    override DataFlow::Node getUrlPatternArg() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("rule")]
    }

    override Function getARouteHandler() {
      exists(DataFlow::Node view_func_arg, DataFlow::Node func_src |
        view_func_arg.asCfgNode() in [node.getArg(2), node.getArgByName("view_func")] and
        DataFlow::localFlow(func_src, view_func_arg) and
        func_src.asExpr().(CallableExpr) = result.getDefinition()
      )
    }
  }

  // ---------------------------------------------------------------------------
  // flask.Request taint modeling
  // ---------------------------------------------------------------------------
  // TODO: Do we even need this class? :|
  /**
   * A source of remote flow from a flask request.
   *
   * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Request
   */
  private class RequestSource extends RemoteFlowSource::Range {
    RequestSource() { this = flask::request() }

    override string getSourceType() { result = "flask.request" }
  }

  private module FlaskRequestTracking {
    /** Gets a reference to the `get_data` attribute of a Flask request. */
    private DataFlow::Node get_data(DataFlow::TypeTracker t) {
      t.startInAttr("get_data") and
      result = flask::request()
      or
      exists(DataFlow::TypeTracker t2 | result = get_data(t2).track(t2, t))
    }

    /** Gets a reference to the `get_data` attribute of a Flask request. */
    DataFlow::Node get_data() { result = get_data(DataFlow::TypeTracker::end()) }

    /** Gets a reference to the `get_json` attribute of a Flask request. */
    private DataFlow::Node get_json(DataFlow::TypeTracker t) {
      t.startInAttr("get_json") and
      result = flask::request()
      or
      exists(DataFlow::TypeTracker t2 | result = get_json(t2).track(t2, t))
    }

    /** Gets a reference to the `get_json` attribute of a Flask request. */
    DataFlow::Node get_json() { result = get_json(DataFlow::TypeTracker::end()) }

    /** Gets a reference to either of the `get_json` or `get_data` attributes of a Flask request. */
    DataFlow::Node tainted_methods(string attr_name) {
      result = get_data() and
      attr_name = "get_data"
      or
      result = get_json() and
      attr_name = "get_json"
    }
  }

  /**
   * A source of remote flow from attributes from a flask request.
   *
   * See https://flask.palletsprojects.com/en/1.1.x/api/#flask.Request
   */
  private class RequestInputAccess extends RemoteFlowSource::Range {
    string attr_name;

    RequestInputAccess() {
      // attributes
      exists(AttrNode attr |
        this.asCfgNode() = attr and attr.getObject(attr_name) = flask::request().asCfgNode()
      |
        attr_name in [
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
      or
      // methods (needs special handling to track bound-methods -- see `FlaskRequestMethodCallsAdditionalTaintStep` below)
      this = FlaskRequestTracking::tainted_methods(attr_name)
    }

    override string getSourceType() { result = "flask.request input" }
  }

  private class FlaskRequestMethodCallsAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      // NOTE: `request -> request.tainted_method` part is handled as part of RequestInputAccess
      // tainted_method -> tainted_method()
      nodeFrom = FlaskRequestTracking::tainted_methods(_) and
      nodeTo.asCfgNode().(CallNode).getFunction() = nodeFrom.asCfgNode()
    }
  }

  private class RequestInputMultiDict extends RequestInputAccess,
    Werkzeug::werkzeug::datastructures::MultiDict::InstanceSource {
    RequestInputMultiDict() { attr_name in ["args", "values", "form", "files"] }
  }

  private class RequestInputFiles extends RequestInputMultiDict {
    RequestInputFiles() { attr_name = "files" }
  }

  // TODO: Somehow specify that elements of `RequestInputFiles` are
  // Werkzeug::werkzeug::datastructures::FileStorage and should have those additional taint steps
  // AND that the 0-indexed argument to its' save method is a sink for path-injection.
  // https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.FileStorage.save
  // ---------------------------------------------------------------------------
  // Response modeling
  // ---------------------------------------------------------------------------
  /**
   * A call to either `flask.make_response` function, or the `make_response` method on
   * an instance of `flask.Flask`.
   *
   * See
   * - https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.make_response
   * - https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response
   */
  private class FlaskMakeResponseCall extends HTTP::Server::HttpResponse::Range, DataFlow::CfgNode {
    override CallNode node;

    FlaskMakeResponseCall() {
      node.getFunction() = flask::make_response().asCfgNode()
      or
      node.getFunction() = flask::Flask::make_response_().asCfgNode()
    }

    override DataFlow::Node getBody() { result.asCfgNode() = node.getArg(0) }

    override string getMimetypeDefault() { result = "text/html" }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }
  }

  private class FlaskRouteHandlerReturn extends HTTP::Server::HttpResponse::Range, DataFlow::CfgNode {
    FlaskRouteHandlerReturn() {
      exists(Function routeHandler |
        routeHandler = any(FlaskRouteSetup rs).getARouteHandler() and
        node = routeHandler.getAReturnValueFlowNode()
      )
    }

    override DataFlow::Node getBody() { result = this }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    override string getMimetypeDefault() { result = "text/html" }
  }
}
