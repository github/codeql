import python

import semmle.python.security.TaintTracking
import semmle.python.security.strings.Basic
import semmle.python.web.Http
import TurboGears



class ControllerMethodReturnValue extends HttpResponseTaintSink {

    ControllerMethodReturnValue() {
        exists(TurboGearsControllerMethod m |
            m.getAReturnValueFlowNode() = this and
            not m.isTemplated()
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringKind
    }

}

class ControllerMethodTemplatedReturnValue extends HttpResponseTaintSink {

    ControllerMethodTemplatedReturnValue() {
        exists(TurboGearsControllerMethod m |
            m.getAReturnValueFlowNode() = this and
            m.isTemplated()
        )
    }

    override predicate sinks(TaintKind kind) {
        kind instanceof StringDictKind
    }

}
