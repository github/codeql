import python
import semmle.python.regex

import semmle.python.security.TaintTracking
import semmle.python.web.Http


/** A django.request.HttpRequest object */
class DjangoRequest extends TaintKind {

    DjangoRequest() {
        this = "django.request.HttpRequest"
    }

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
pragma [noinline]
private predicate subscript_taint(SubscriptNode sub, ControlFlowNode obj, TaintKind kind) {
    sub.getValue() = obj and
    kind instanceof ExternalStringKind
}

/** A django.request.QueryDict object */
class DjangoQueryDict extends TaintKind {

    DjangoQueryDict() {
        this = "django.http.request.QueryDict"
    }

    override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
        this.taints(fromnode) and
        subscript_taint(tonode, fromnode, result)
    }

    override TaintKind getTaintOfMethodResult(string name) {
        name = "get" and result instanceof ExternalStringKind
    }

}

abstract class DjangoRequestSource extends HttpRequestTaintSource {

    override string toString() {
        result = "Django request source"
    }

    override predicate isSourceOf(TaintKind kind) {
        kind instanceof DjangoRequest
    }

}

/** Function based views 
 * https://docs.djangoproject.com/en/1.11/topics/http/views/
 */
private class DjangoFunctionBasedViewRequestArgument extends DjangoRequestSource {

    DjangoFunctionBasedViewRequestArgument() {
        exists(FunctionObject view |
            url_dispatch(_, _, view) and
            this = view.getFunction().getArg(0).asName().getAFlowNode()
        )
    }

}

/** Class based views 
 * https://docs.djangoproject.com/en/1.11/topics/class-based-views/
 * 
 */
private class DjangoView extends ClassObject {

    DjangoView() {
        ModuleObject::named("django.views.generic").attr("View") = this.getAnImproperSuperType()
    }
}

private FunctionObject djangoViewHttpMethod() {
    exists(DjangoView view |
        view.lookupAttribute(httpVerbLower()) = result
    )
}

class DjangoClassBasedViewRequestArgument extends DjangoRequestSource {

    DjangoClassBasedViewRequestArgument() {
        this = djangoViewHttpMethod().getFunction().getArg(1).asName().getAFlowNode()
    }

}




/* ***********  Routing  ********* */


/* Function based views */
predicate url_dispatch(CallNode call, ControlFlowNode regex, FunctionObject view) {
    exists(FunctionObject url |
        ModuleObject::named("django.conf.urls").attr("url") = url and
        url.getArgumentForCall(call, 0) = regex and
        url.getArgumentForCall(call, 1).refersTo(view)
    )
}


class UrlRegex extends RegexString {

    UrlRegex() {
        url_dispatch(_, this.getAFlowNode(), _)
    }

}

class UrlRouting extends CallNode {

    UrlRouting() {
        url_dispatch(this, _, _)
    }

    FunctionObject getViewFunction() {
        url_dispatch(this, _, result)
    }

    string getNamedArgument() {
        exists(UrlRegex regex |
            url_dispatch(this, regex.getAFlowNode(), _) and
            regex.getGroupName(_, _) = result
        )
    }

}

/** An argument specified in a url routing table */
class HttpRequestParameter extends HttpRequestTaintSource {

    HttpRequestParameter() {
        exists(UrlRouting url |
            this.(ControlFlowNode).getNode() = 
            url.getViewFunction().getFunction().getArgByName(url.getNamedArgument())
        )
    }

    override predicate isSourceOf(TaintKind kind) { 
        kind instanceof ExternalStringKind
    }

    override string toString() {
        result = "django.http.request.parameter"
    }
}

