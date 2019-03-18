import python

import semmle.python.security.TaintTracking
import semmle.python.security.strings.Untrusted
import semmle.python.web.Http
import semmle.python.web.bottle.General


/** A bottle.Response object
 * This isn't really a "taint", but we use the value tracking machinery to
 * track the flow of response objects.
 */
class BottleResponse extends TaintKind {

    BottleResponse() {
        this = "bottle.response"
    }

}

private Object theBottleResponseObject() {
    result = theBottleModule().attr("response")
}

class BottleResponseBodyAssignment extends SimpleHttpResponseTaintSink {

    BottleResponseBodyAssignment() {
        exists(DefinitionNode lhs |
            lhs.getValue() = this and
            lhs.(AttrNode).getObject("body").refersTo(theBottleResponseObject())
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringKind
    }

}

class BottleHandlerFunctionResult extends SimpleHttpResponseTaintSink {

    BottleHandlerFunctionResult() {
        exists(BottleRoute route, Return ret |
            ret.getScope() = route.getFunction() and
            ret.getValue().getAFlowNode() = this
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringKind
    }

    override string toString() {
        result = "bottle handler function result"
    }

}

