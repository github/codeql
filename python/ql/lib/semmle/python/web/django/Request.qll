import python
import semmle.python.dataflow.TaintTracking
import semmle.python.web.Http
import semmle.python.web.django.General

/** A django.request.HttpRequest object */
deprecated class DjangoRequest extends TaintKind {
  DjangoRequest() { this = "django.request.HttpRequest" }

  override TaintKind getTaintOfAttribute(string name) {
    (name = "GET" or name = "POST") and
    result instanceof DjangoQueryDict
  }

  override TaintKind getTaintOfMethodResult(string name) {
    (name = "body" or name = "path") and
    result instanceof ExternalStringKind
  }
}

/* Helper for getTaintForStep() */
pragma[noinline]
deprecated private predicate subscript_taint(SubscriptNode sub, ControlFlowNode obj, TaintKind kind) {
  sub.getObject() = obj and
  kind instanceof ExternalStringKind
}

/** A django.request.QueryDict object */
deprecated class DjangoQueryDict extends TaintKind {
  DjangoQueryDict() { this = "django.http.request.QueryDict" }

  override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
    this.taints(fromnode) and
    subscript_taint(tonode, fromnode, result)
  }

  override TaintKind getTaintOfMethodResult(string name) {
    name = "get" and result instanceof ExternalStringKind
  }
}

/** A Django request parameter */
deprecated class DjangoRequestSource extends HttpRequestTaintSource {
  DjangoRequestSource() {
    exists(DjangoRoute route, DjangoViewHandler view, int request_arg_index |
      route.getViewHandler() = view and
      request_arg_index = view.getRequestArgIndex() and
      this = view.getScope().getArg(request_arg_index).asName().getAFlowNode()
    )
  }

  override string toString() { result = "Django request source" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof DjangoRequest }
}

/** An argument specified in a url routing table */
deprecated class DjangoRequestParameter extends HttpRequestTaintSource {
  DjangoRequestParameter() {
    exists(DjangoRoute route, Function f, DjangoViewHandler view, int request_arg_index |
      route.getViewHandler() = view and
      request_arg_index = view.getRequestArgIndex() and
      f = view.getScope()
    |
      this.(ControlFlowNode).getNode() = f.getArgByName(route.getANamedArgument())
      or
      exists(int i | i >= 0 |
        i < route.getNumPositionalArguments() and
        // +1 because first argument is always the request
        this.(ControlFlowNode).getNode() = f.getArg(request_arg_index + 1 + i)
      )
    )
  }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringKind }

  override string toString() { result = "django.http.request.parameter" }
}
