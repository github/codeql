import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic
import semmle.python.web.flask.General

/**
 * A flask response, which is vulnerable to any sort of
 * http response malice.
 */
deprecated class FlaskRoutedResponse extends HttpResponseTaintSink {
  FlaskRoutedResponse() {
    exists(PythonFunctionValue response |
      flask_routing(_, response.getScope()) and
      this = response.getAReturnedNode()
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof StringKind }

  override string toString() { result = "flask.routed.response" }
}

deprecated class FlaskResponseArgument extends HttpResponseTaintSink {
  FlaskResponseArgument() {
    exists(CallNode call |
      (
        call.getFunction().pointsTo(theFlaskReponseClass())
        or
        call.getFunction().pointsTo(Value::named("flask.make_response"))
      ) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof StringKind }

  override string toString() { result = "flask.response.argument" }
}

deprecated class FlaskResponseTaintKind extends TaintKind {
  FlaskResponseTaintKind() { this = "flask.Response" }
}

deprecated class FlaskResponseConfiguration extends TaintTracking::Configuration {
  FlaskResponseConfiguration() { this = "Flask response configuration" }

  override predicate isSource(DataFlow::Node node, TaintKind kind) {
    kind instanceof FlaskResponseTaintKind and
    (
      node.asCfgNode().(CallNode).getFunction().pointsTo(theFlaskReponseClass())
      or
      node.asCfgNode().(CallNode).getFunction().pointsTo(Value::named("flask.make_response"))
    )
  }
}
