import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic
private import semmle.python.web.django.Shared
private import semmle.python.web.Http

/**
 * A django.http.response.Response object
 * This isn't really a "taint", but we use the value tracking machinery to
 * track the flow of response objects.
 */
class DjangoResponse extends TaintKind {
    DjangoResponse() { this = "django.response.HttpResponse" }
}

private ClassValue theDjangoHttpResponseClass() {
    (
        // version 1.x
        result = Value::named("django.http.response.HttpResponse")
        or
        // version 2.x
        // https://docs.djangoproject.com/en/2.2/ref/request-response/#httpresponse-objects
        result = Value::named("django.http.HttpResponse")
    ) and
    // TODO: does this do anything? when could they be the same???
    not result = theDjangoHttpRedirectClass()
}

/** internal class used for tracking a django response. */
private class DjangoResponseSource extends TaintSource {
    DjangoResponseSource() {
        exists(ClassValue cls |
            cls.getASuperType() = theDjangoHttpResponseClass() and
            cls.getACall() = this
        )
    }

    override predicate isSourceOf(TaintKind kind) { kind instanceof DjangoResponse }

    override string toString() { result = "django.http.response.HttpResponse" }
}

/** A write to a django response, which is vulnerable to external data (xss) */
class DjangoResponseWrite extends HttpResponseTaintSink {
    DjangoResponseWrite() {
        exists(AttrNode meth, CallNode call |
            call.getFunction() = meth and
            any(DjangoResponse response).taints(meth.getObject("write")) and
            this = call.getArg(0)
        )
    }

    override predicate sinks(TaintKind kind) { kind instanceof StringKind }

    override string toString() { result = "django.Response.write(...)" }
}

/** An argument to initialization of a django response, which is vulnerable to external data (xss) */
class DjangoResponseContent extends HttpResponseTaintSink {
    DjangoResponseContent() {
        exists(CallNode call, ClassValue cls |
            cls.getASuperType() = theDjangoHttpResponseClass() and
            call.getFunction().pointsTo(cls)
        |
            call.getArg(0) = this
            or
            call.getArgByName("content") = this
        )
    }

    override predicate sinks(TaintKind kind) { kind instanceof StringKind }

    override string toString() { result = "django.Response(...)" }
}

class DjangoCookieSet extends CookieSet, CallNode {
    DjangoCookieSet() {
        any(DjangoResponse r).taints(this.getFunction().(AttrNode).getObject("set_cookie"))
    }

    override string toString() { result = CallNode.super.toString() }

    override ControlFlowNode getKey() { result = this.getArg(0) }

    override ControlFlowNode getValue() { result = this.getArg(1) }
}
