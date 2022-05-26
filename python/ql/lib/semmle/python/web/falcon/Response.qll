import python
import semmle.python.dataflow.TaintTracking
import semmle.python.web.Http
import semmle.python.web.falcon.General

/** https://falcon.readthedocs.io/en/stable/api/request_and_response.html */
deprecated class FalconResponse extends TaintKind {
  FalconResponse() { this = "falcon.response" }
}

/** Only used internally to track the response parameter */
deprecated private class FalconResponseParameter extends TaintSource {
  FalconResponseParameter() {
    exists(FalconHandlerFunction f | f.getResponse() = this.(ControlFlowNode).getNode())
  }

  override predicate isSourceOf(TaintKind k) { k instanceof FalconResponse }
}

deprecated class FalconResponseBodySink extends HttpResponseTaintSink {
  FalconResponseBodySink() {
    exists(AttrNode attr | any(FalconResponse f).taints(attr.getObject("body")) |
      attr.(DefinitionNode).getValue() = this
    )
  }

  override predicate sinks(TaintKind kind) { kind instanceof StringKind }
}
