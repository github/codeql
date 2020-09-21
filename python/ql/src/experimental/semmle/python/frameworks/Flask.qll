/**
 * Provides classes modeling security-relevant aspects of the `flask` package.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts
private import experimental.semmle.python.frameworks.Werkzeug

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

  // TODO: Do we even need this class then? :|
  private class RequestSource extends RemoteFlowSource::Range {
    RequestSource() { this = flask::request() }

    override string getSourceType() { result = "flask.request" }
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
      // methods
      exists(CallNode call | this.asCfgNode() = call |
        // NOTE: will not track bound method, `f = obj.func; f()`
        attr_name in ["get_data", "get_json"] and
        call.getFunction().(AttrNode).getObject(attr_name) = flask::request().asCfgNode()
      )
    }

    override string getSourceType() { result = "flask.request input" }
  }

  private class RequestInputMultiDict extends RequestInputAccess,
    Werkzeug::Datastructures::MultiDict {
    RequestInputMultiDict() { attr_name in ["args", "values", "form", "files"] }
  }

  private class RequestInputFiles extends RequestInputMultiDict {
    RequestInputFiles() { attr_name = "files" }
  }

  private class RequestInputFileStorage extends Werkzeug::Datastructures::FileStorage {
    RequestInputFileStorage() {
      exists(RequestInputFiles files, Werkzeug::Datastructures::MultiDictTracked filesTracked |
        filesTracked.getMultiDict() = files and
        this = filesTracked.getElementAccess()
      )
    }
  }
}
