import python
import semmle.python.dataflow.TaintTracking
import semmle.python.web.Http
import Tornado

/** A tornado.request.HttpRequest object */
class TornadoRequest extends TaintKind {
  TornadoRequest() { this = "tornado.request.HttpRequest" }

  override TaintKind getTaintOfAttribute(string name) {
    result instanceof ExternalStringDictKind and
    (
      name = "headers" or
      name = "cookies"
    )
    or
    result instanceof ExternalStringKind and
    (
      name = "uri" or
      name = "query" or
      name = "body"
    )
    or
    result instanceof ExternalStringSequenceDictKind and
    (
      name = "arguments" or
      name = "query_arguments" or
      name = "body_arguments"
    )
  }
}

class TornadoRequestSource extends HttpRequestTaintSource {
  TornadoRequestSource() { isTornadoRequestHandlerInstance(this.(AttrNode).getObject("request")) }

  override string toString() { result = "Tornado request source" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof TornadoRequest }
}

class TornadoExternalInputSource extends HttpRequestTaintSource {
  TornadoExternalInputSource() {
    exists(string name |
      name = "get_argument" or
      name = "get_query_argument" or
      name = "get_body_argument" or
      name = "decode_argument"
    |
      this = callToNamedTornadoRequestHandlerMethod(name)
    )
  }

  override string toString() { result = "Tornado request method" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringKind }
}

class TornadoExternalInputListSource extends HttpRequestTaintSource {
  TornadoExternalInputListSource() {
    exists(string name |
      name = "get_arguments" or
      name = "get_query_arguments" or
      name = "get_body_arguments"
    |
      this = callToNamedTornadoRequestHandlerMethod(name)
    )
  }

  override string toString() { result = "Tornado request method" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringSequenceKind }
}
