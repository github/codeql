import python

import semmle.python.security.TaintTracking
import semmle.python.security.strings.Untrusted
import semmle.python.web.Http
import semmle.python.web.cherrypy.General



class CherryPyExposedFunctionResult extends SimpleHttpResponseTaintSink {

    CherryPyExposedFunctionResult() {
        exists(Return ret |
            ret.getScope() instanceof CherryPyExposedFunction and
            ret.getValue().getAFlowNode() = this
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringKind
    }

    override string toString() {
        result = "cherrypy handler function result"
    }

}

