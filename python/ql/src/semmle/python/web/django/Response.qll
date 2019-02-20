import python
import semmle.python.security.TaintTracking
import semmle.python.security.strings.Basic
private import semmle.python.web.django.Shared


/** A django.http.response.Response object
 * This isn't really a "taint", but we use the value tracking machinery to
 * track the flow of response objects.
 */
class DjangoResponse extends TaintKind {

    DjangoResponse() {
        this = "django.response.HttpResponse"
    }

}

private ClassObject theDjangoHttpResponseClass() {
    result = any(ModuleObject m | m.getName() = "django.http.response").attr("HttpResponse") and
    not result = theDjangoHttpRedirectClass()
}

/** Instantiation of a django response. */
class DjangoResponseSource extends TaintSource {

    DjangoResponseSource() {
        exists(ClassObject cls |
            cls.getAnImproperSuperType() = theDjangoHttpResponseClass() and
            cls.getACall() = this
        )
    }

    override predicate isSourceOf(TaintKind kind) { kind instanceof DjangoResponse }

    override string toString() {
        result = "django.http.response.HttpResponse"
    }
}

/** A write to a django response, which is vulnerable to external data (xss) */
class DjangoResponseWrite extends TaintSink {

    DjangoResponseWrite() {
        exists(AttrNode meth, CallNode call |
            call.getFunction() = meth and
            any(DjangoResponse repsonse).taints(meth.getObject("write")) and
            this = call.getArg(0)
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringKind
    }

    override string toString() {
        result = "django.Response.write(...)"
    }

}

/** An argument to initialization of a django response, which is vulnerable to external data (xss) */
class DjangoResponseContent extends TaintSink {

    DjangoResponseContent() {
        exists(CallNode call, ClassObject cls |
            cls.getAnImproperSuperType() = theDjangoHttpResponseClass() and
            call.getFunction().refersTo(cls) |
            call.getArg(0) = this
            or
            call.getArgByName("content") = this
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringKind
    }

    override string toString() {
        result = "django.Response(...)"
    }

}



