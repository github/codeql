import python
import semmle.python.security.TaintTracking
import semmle.python.security.strings.External
import HttpConstants

/** Generic taint source from a http request */
abstract class HttpRequestTaintSource extends TaintSource {

}

/** Taint kind representing the WSGI environment.
 * As specified in PEP 3333. https://www.python.org/dev/peps/pep-3333/#environ-variables
 */
class WsgiEnvironment extends TaintKind {

    WsgiEnvironment() { this = "wsgi.environment" }

    override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
        result = this and TaintFlowImplementation::copyCall(fromnode, tonode)
        or
        result = this and
        tonode.(CallNode).getFunction().refersTo(theDictType()) and
        tonode.(CallNode).getArg(0) = fromnode
        or
        exists(StringObject key, string text |
            tonode.(CallNode).getFunction().(AttrNode).getObject("get") = fromnode and
            tonode.(CallNode).getArg(0).refersTo(key)
            or
            tonode.(SubscriptNode).getValue() = fromnode and tonode.isLoad() and
            tonode.(SubscriptNode).getIndex().refersTo(key)
            |
            text = key.getText() and result instanceof ExternalStringKind and
            (
                text = "QUERY_STRING" or
                text = "PATH_INFO" or
                text.prefix(5) = "HTTP_"
            )
        )
    }

}

/** A standard morsel object from a HTTP request, a value in a cookie,
 * typically an instance of `http.cookies.Morsel` */
class UntrustedMorsel extends TaintKind {

    UntrustedMorsel() {
        this = "http.Morsel"
    }


    override TaintKind getTaintOfAttribute(string name) {
        result instanceof ExternalStringKind and
        (
            name = "value"
        )
    }

}

/** A standard cookie object from a HTTP request, typically an instance of `http.cookies.SimpleCookie` */
class UntrustedCookie extends TaintKind {

    UntrustedCookie() {
        this = "http.Cookie"
    }

    override TaintKind getTaintForFlowStep(ControlFlowNode fromnode, ControlFlowNode tonode) {
        tonode.(SubscriptNode).getValue() = fromnode and
        result instanceof UntrustedMorsel
    }

}


/** Generic taint sink in a http response */
abstract class HttpResponseTaintSink extends TaintSink {

    override predicate sinks(TaintKind kind) { 
        kind instanceof ExternalStringKind
    }

}

abstract class HttpRedirectTaintSink extends TaintSink {

    override predicate sinks(TaintKind kind) { 
        kind instanceof ExternalStringKind
    }

}

