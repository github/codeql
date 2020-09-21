/**
 * Provides classes modeling security-relevant aspects of the `flask` package.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts

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

  // https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.MultiDict
  /** Gets a reference to the MultiDict attributes of `flask.request`. */
  DataFlow::Node requestMultiDictAttribute(DataFlow::TypeTracker t) {
    t.start() and
    result.asCfgNode().(AttrNode).getObject(["args", "values", "form"]) =
      flask::request().asCfgNode()
    or
    exists(DataFlow::TypeTracker t2 | result = requestMultiDictAttribute(t2).track(t2, t))
  }

  /** Gets a reference to the MultiDict attributes of `flask.request`. */
  DataFlow::Node requestMultiDictAttribute() {
    result = requestMultiDictAttribute(DataFlow::TypeTracker::end())
  }

  private class RequestInputAccess extends RemoteFlowSource::Range {
    RequestInputAccess() {
      // attributes
      exists(AttrNode attr, string name |
        this.asCfgNode() = attr and attr.getObject(name) = flask::request().asCfgNode()
      |
        name in ["path",
              // string
              "full_path", "base_url", "url", "access_control_request_method", "content_encoding",
              "content_md5", "content_type", "data", "method", "mimetype", "origin", "query_string",
              "referrer", "remote_addr", "remote_user", "user_agent",
              // dict
              "environ", "cookies", "mimetype_params", "view_args",
              //
              "args", "values", "form",
              // json
              "json",
              // List[str]
              "access_route",
              // file-like
              "stream", "input_stream",
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
              // TODO: MultiDict[FileStorage]
              // https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.FileStorage
              "files",
              // https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.Headers
              // TODO: dict-like with wsgiref.headers.Header compatibility methods
              "headers"]
      )
      or
      // methods
      exists(CallNode call, string name | this.asCfgNode() = call |
        // NOTE: will not track bound method, `f = func; f()`
        name in ["get_data", "get_json"] and
        call.getFunction().(AttrNode).getObject(name) = flask::request().asCfgNode()
      )
      or
      // multi dict special handling
      (
        this = requestMultiDictAttribute()
        or
        exists(CallNode call | this.asCfgNode() = call |
          // NOTE: will not track bound method, `f = func; f()`
          call.getFunction().(AttrNode).getObject("getlist") =
            requestMultiDictAttribute().asCfgNode()
        )
      )
    }

    override string getSourceType() { result = "flask.request input" }
  }
}
