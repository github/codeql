import python
import semmle.python.dataflow.TaintTracking
import semmle.python.web.Http
import semmle.python.web.falcon.General
import semmle.python.security.strings.External

/** https://falcon.readthedocs.io/en/stable/api/request_and_response.html */
class FalconRequest extends TaintKind {
  FalconRequest() { this = "falcon.request" }

  override TaintKind getTaintOfAttribute(string name) {
    name = "env" and result instanceof WsgiEnvironment
    or
    result instanceof ExternalStringKind and
    (
      name = "uri" or
      name = "url" or
      name = "forwarded_uri" or
      name = "relative_uri" or
      name = "query_string"
    )
    or
    result instanceof ExternalStringDictKind and
    (name = "cookies" or name = "params")
    or
    name = "stream" and result instanceof ExternalFileObject
  }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "get_param" and result instanceof ExternalStringKind
    or
    name = "get_param_as_json" and result instanceof ExternalJsonKind
    or
    name = "get_param_as_list" and result instanceof ExternalStringSequenceKind
  }
}

class FalconRequestParameter extends HttpRequestTaintSource {
  FalconRequestParameter() {
    exists(FalconHandlerFunction f | f.getRequest() = this.(ControlFlowNode).getNode())
  }

  override predicate isSourceOf(TaintKind k) { k instanceof FalconRequest }
}
