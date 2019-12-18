import python
import semmle.python.security.TaintTracking
import semmle.python.web.Http
import semmle.python.web.django.General

/** A django.request.HttpRequest object */
class DjangoRequest extends TaintKind {
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
private predicate subscript_taint(SubscriptNode sub, ControlFlowNode obj, TaintKind kind) {
    sub.getValue() = obj and
    kind instanceof ExternalStringKind
}

/** A django.request.QueryDict object */
class DjangoQueryDict extends TaintKind {
    DjangoQueryDict() { this = "django.http.request.QueryDict" }

    override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
        this.taints(fromnode) and
        subscript_taint(tonode, fromnode, result)
    }

    override TaintKind getTaintOfMethodResult(string name) {
        name = "get" and result instanceof ExternalStringKind
    }
}

abstract class DjangoRequestSource extends HttpRequestTaintSource {
    override string toString() { result = "Django request source" }

    override predicate isSourceOf(TaintKind kind) { kind instanceof DjangoRequest }
}

/**
 * Function based views
 * https://docs.djangoproject.com/en/1.11/topics/http/views/
 */
private class DjangoFunctionBasedViewRequestArgument extends DjangoRequestSource {
    DjangoFunctionBasedViewRequestArgument() {
        exists(FunctionValue view |
            django_route(_, _, view) and
            this = view.getScope().getArg(0).asName().getAFlowNode()
        )
    }
}

/**
 * Class based views
 * https://docs.djangoproject.com/en/1.11/topics/class-based-views/
 */
private class DjangoView extends ClassValue {
    DjangoView() { Value::named("django.views.generic.View") = this.getASuperType() }
}

private FunctionValue djangoViewHttpMethod() {
    exists(DjangoView view | view.lookup(httpVerbLower()) = result)
}

class DjangoClassBasedViewRequestArgument extends DjangoRequestSource {
    DjangoClassBasedViewRequestArgument() {
        this = djangoViewHttpMethod().getScope().getArg(1).asName().getAFlowNode()
    }
}

/** An argument specified in a url routing table */
class DjangoRequestParameter extends HttpRequestTaintSource {
    DjangoRequestParameter() {
        exists(DjangoRoute route, Function f |
            f = route.getViewFunction().getScope() |
            this.(ControlFlowNode).getNode() = f.getArgByName(route.getNamedArgument())
            or
            exists(int i | i >= 0 |
                i < route.getNumPositionalArguments() and
                // +1 because first argument is always the request
                this.(ControlFlowNode).getNode() = f.getArg(i+1)
            )
        )
    }

    override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringKind }

    override string toString() { result = "django.http.request.parameter" }
}
