import python
import semmle.python.dataflow.TaintTracking
import semmle.python.web.Http
import semmle.python.web.flask.General

deprecated private Value theFlaskRequestObject() { result = Value::named("flask.request") }

/** Holds if `attr` is an access of attribute `name` of the flask request object */
deprecated private predicate flask_request_attr(AttrNode attr, string name) {
  attr.isLoad() and
  attr.getObject(name).pointsTo(theFlaskRequestObject())
}

/** Source of external data from a flask request */
deprecated class FlaskRequestData extends HttpRequestTaintSource {
  FlaskRequestData() {
    not this instanceof FlaskRequestArgs and
    exists(string name | flask_request_attr(this, name) |
      name in ["path", "full_path", "base_url", "url"]
    )
  }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringKind }

  override string toString() { result = "flask.request" }
}

/** Source of dictionary whose values are externally controlled */
deprecated class FlaskRequestArgs extends HttpRequestTaintSource {
  FlaskRequestArgs() {
    exists(string attr | flask_request_attr(this, attr) |
      attr in ["args", "form", "values", "files", "headers", "json"]
    )
  }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringDictKind }

  override string toString() { result = "flask.request.args" }
}

/** Source of dictionary whose values are externally controlled */
deprecated class FlaskRequestJson extends HttpRequestTaintSource {
  FlaskRequestJson() { flask_request_attr(this, "json") }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalJsonKind }

  override string toString() { result = "flask.request.json" }
}

/**
 * A parameter to a flask request handler, that can capture a part of the URL (as specified in
 * the url-pattern of a route).
 *
 * For example, the `name` parameter in:
 * ```
 * @app.route('/hello/<name>')
 * def hello(name):
 * ```
 */
deprecated class FlaskRoutedParameter extends HttpRequestTaintSource {
  FlaskRoutedParameter() {
    exists(string name, Function func, StrConst url_pattern |
      this.(ControlFlowNode).getNode() = func.getArgByName(name) and
      flask_routing(url_pattern.getAFlowNode(), func) and
      exists(string match |
        match = url_pattern.getS().regexpFind(werkzeug_rule_re(), _, _) and
        name = match.regexpCapture(werkzeug_rule_re(), 4)
      )
    )
  }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringKind }
}

deprecated private string werkzeug_rule_re() {
  // since flask uses werkzeug internally, we are using its routing rules from
  // https://github.com/pallets/werkzeug/blob/4dc8d6ab840d4b78cbd5789cef91b01e3bde01d5/src/werkzeug/routing.py#L138-L151
  result =
    "(?<static>[^<]*)<(?:(?<converter>[a-zA-Z_][a-zA-Z0-9_]*)(?:\\((?<args>.*?)\\))?\\:)?(?<variable>[a-zA-Z_][a-zA-Z0-9_]*)>"
}
