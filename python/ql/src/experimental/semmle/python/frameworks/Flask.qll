/**
 * Provides classes modeling security-relevant aspects of the `flask` package.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.dataflow.TaintTracking
private import experimental.semmle.python.Concepts
private import experimental.semmle.python.frameworks.Werkzeug

// for old improved impl see
// https://github.com/github/codeql/blob/9f95212e103c68d0c1dfa4b6f30fb5d53954ccef/python/ql/src/semmle/python/web/flask/Request.qll
private module Flask {
  /** Gets a reference to the `flask` module. */
  DataFlow::Node flask(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importModule("flask")
    or
    exists(DataFlow::TypeTracker t2 | result = flask(t2).track(t2, t))
  }

  /** Gets a reference to the `flask` module. */
  DataFlow::Node flask() { result = flask(DataFlow::TypeTracker::end()) }

  module flask {
    /** Gets a reference to the `flask.request` object. */
    DataFlow::Node request(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::importMember("flask", "request")
      or
      t.startInAttr("request") and
      result = flask()
      or
      exists(DataFlow::TypeTracker t2 | result = flask::request(t2).track(t2, t))
    }

    /** Gets a reference to the `flask.request` object. */
    DataFlow::Node request() { result = flask::request(DataFlow::TypeTracker::end()) }
  }

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
        attr_name in ["path",
              // str
              "full_path", "base_url", "url", "access_control_request_method", "content_encoding",
              "content_md5", "content_type", "data", "method", "mimetype", "origin", "query_string",
              "referrer", "remote_addr", "remote_user", "user_agent",
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
              "headers"]
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
    Werkzeug::Datastructures::MultiDict {
    RequestInputMultiDict() { attr_name in ["args", "values", "form", "files"] }
  }

  private class RequestInputFiles extends RequestInputMultiDict {
    RequestInputFiles() { attr_name = "files" }
  }
  // TODO: Somehow specify that elements of `RequestInputFiles` are
  // Werkzeug::Datastructures::FileStorage and should have those additional taint steps
  // AND that the 0-indexed argument to its' save method is a sink for path-injection.
  // https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.FileStorage.save
}
